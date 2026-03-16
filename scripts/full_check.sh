#!/usr/bin/env bash
set -Eeuo pipefail

echo "======================================"
echo " FULL PROJECT CHECK"
echo "======================================"

fail=0
warn=0

section() {
  echo ""
  echo "---- $1 ----"
}

ok() { echo "OK: $1"; }
w() { echo "WARN: $1"; warn=$((warn+1)); }
e() { echo "ERROR: $1"; fail=$((fail+1)); }

require_file() {
  if [ -f "$1" ]; then ok "$1 exists"; else e "$1 missing"; fi
}

require_dir() {
  if [ -d "$1" ]; then ok "$1 directory exists"; else w "$1 directory missing"; fi
}

section "1. Project files"
require_file docker-compose.yml
require_file README.md
require_file .gitignore

require_dir astro
require_dir haproxy
require_dir scripts

section "2. Docker"
if command -v docker >/dev/null 2>&1; then
  docker --version
  ok "docker installed"
else
  e "docker not installed"
fi

if docker compose version >/dev/null 2>&1; then
  docker compose version
  ok "docker compose working"
else
  e "docker compose missing"
fi

section "3. docker-compose validation"

if docker compose config >/dev/null 2>&1; then
  ok "docker-compose syntax valid"
else
  e "docker-compose syntax invalid"
fi

services=$(docker compose config --services)

for s in haproxy astro strapi postgres
do
  if echo "$services" | grep -q "$s"; then
    ok "service $s exists"
  else
    e "service $s missing"
  fi
done

section "4. Restart policy"

restart_count=$(grep -c "restart:" docker-compose.yml || true)

if [ "$restart_count" -ge 4 ]; then
  ok "restart policy present"
else
  w "restart: unless-stopped may be missing"
fi

section "5. Healthchecks"

health_count=$(grep -c "healthcheck:" docker-compose.yml || true)

if [ "$health_count" -gt 0 ]; then
  ok "healthchecks detected"
else
  w "no healthchecks configured"
fi

section "6. Postgres volume"

if grep -q "/var/lib/postgresql/data" docker-compose.yml; then
  ok "postgres volume configured"
else
  e "postgres volume missing"
fi

section "7. .env file"

if [ -f ".env" ]; then
  ok ".env present"
else
  w ".env missing"
fi

section "8. Astro Dockerfile"

if [ -f astro/Dockerfile ]; then
  ok "Dockerfile exists"

  if grep -q "npm ci" astro/Dockerfile; then
    if [ -f astro/package-lock.json ]; then
      ok "npm ci safe (lock file exists)"
    else
      e "npm ci used but package-lock.json missing"
    fi
  fi

else
  e "astro Dockerfile missing"
fi

section "9. HAproxy config"

if [ -f haproxy/haproxy.cfg ]; then

  grep -q frontend haproxy/haproxy.cfg && ok "frontend found" || w "frontend missing"
  grep -q backend haproxy/haproxy.cfg && ok "backend found" || e "backend missing"
  grep -q "stats enable" haproxy/haproxy.cfg && ok "stats enabled" || w "stats page missing"

else
  e "haproxy.cfg missing"
fi

section "10. Scenario scripts"

for s in start stop backup restore update logs console
do
  if [ -f scripts/$s.sh ]; then
    ok "scripts/$s.sh exists"
  else
    w "scripts/$s.sh missing"
  fi
done

section "11. Git"

if [ -d .git ]; then
  ok "git repo detected"
else
  e "not a git repository"
fi

git branch | grep develop >/dev/null 2>&1 && ok "develop branch exists" || w "develop branch missing"

section "12. Build containers"

if docker compose build >/dev/null 2>&1; then
  ok "containers build"
else
  e "container build failed"
fi

section "13. Start stack"

docker compose up -d >/dev/null 2>&1 || e "failed to start stack"

sleep 15

section "14. Container status"

docker compose ps

section "15. Health state"

containers=$(docker compose ps -q)

for c in $containers
do
  name=$(docker inspect --format='{{.Name}}' $c | sed 's/\///')
  health=$(docker inspect --format='{{.State.Health.Status}}' $c 2>/dev/null || echo "no-healthcheck")
  echo "$name : $health"
done

section "16. Service connectivity"

if curl -s http://localhost >/dev/null 2>&1; then
  ok "haproxy reachable"
else
  w "haproxy not reachable"
fi

if curl -s http://localhost:1337 >/dev/null 2>&1; then
  ok "strapi reachable"
else
  w "strapi not reachable"
fi

if curl -s http://localhost:4321 >/dev/null 2>&1; then
  ok "astro reachable"
else
  w "astro not reachable"
fi

section "17. Postgres"

docker compose exec postgres pg_isready >/dev/null 2>&1 && ok "postgres ready" || w "postgres not responding"

section "18. Logs (last 10 lines)"

docker compose logs --tail=10

echo ""
echo "======================================"
echo "RESULT"
echo "errors: $fail"
echo "warnings: $warn"
echo "======================================"

if [ "$fail" -eq 0 ]; then
  echo "PROJECT PASSED CHECK"
else
  echo "PROJECT HAS ERRORS"
fi
