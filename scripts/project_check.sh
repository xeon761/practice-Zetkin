#!/usr/bin/env bash

echo "======================================"
echo "PROJECT INFRASTRUCTURE CHECK"
echo "======================================"

fail=0
warn=0

ok(){ echo "OK: $1"; }
w(){ echo "WARN: $1"; warn=$((warn+1)); }
e(){ echo "ERROR: $1"; fail=$((fail+1)); }

echo ""
echo "1. Checking core files"

[ -f docker-compose.yml ] && ok "docker-compose.yml exists" || e "docker-compose.yml missing"
[ -f README.md ] && ok "README exists" || w "README missing"

echo ""
echo "2. Checking services structure"

for svc in astro strapi postgres haproxy
do
 if [ -d services/$svc ]; then
  ok "services/$svc exists"
 else
  e "services/$svc missing"
 fi
done

echo ""
echo "3. Checking service configs"

[ -f services/astro/Dockerfile ] && ok "astro Dockerfile" || e "astro Dockerfile missing"
[ -f services/strapi/Dockerfile ] && ok "strapi Dockerfile" || e "strapi Dockerfile missing"
[ -f services/haproxy/haproxy.cfg ] && ok "haproxy.cfg exists" || e "haproxy.cfg missing"
[ -f services/postgres/init.sql ] && ok "postgres init.sql exists" || w "postgres init.sql missing"

echo ""
echo "4. Checking Node lock files"

if [ -f services/astro/package-lock.json ]; then
 ok "astro package-lock.json exists"
else
 w "astro package-lock.json missing (npm ci may fail)"
fi

echo ""
echo "5. Checking scripts"

for s in start stop backup restore update logs console
do
 if [ -f scripts/$s.sh ]; then
  ok "scripts/$s.sh"
 else
  w "scripts/$s.sh missing"
 fi
done

echo ""
echo "6. Checking docker-compose services"

services=$(docker compose config --services)

for s in haproxy astro strapi postgres
do
 if echo "$services" | grep -q "$s"; then
  ok "compose service $s"
 else
  e "compose missing $s"
 fi
done

echo ""
echo "7. Validating compose syntax"

docker compose config >/dev/null && ok "compose syntax valid" || e "compose syntax error"

echo ""
echo "8. Building containers"

docker compose build && ok "build success" || e "build failed"

echo ""
echo "9. Starting stack"

docker compose up -d && ok "stack started" || e "stack failed"

sleep 15

echo ""
echo "10. Container status"

docker compose ps

echo ""
echo "11. Health status"

containers=$(docker compose ps -q)

for c in $containers
do
 name=$(docker inspect --format='{{.Name}}' $c | sed 's/\///')
 health=$(docker inspect --format='{{.State.Health.Status}}' $c 2>/dev/null || echo "no-healthcheck")
 echo "$name : $health"
done

echo ""
echo "12. Connectivity tests"

curl -s http://localhost >/dev/null && ok "haproxy reachable" || w "haproxy not reachable"
curl -s http://localhost:1337 >/dev/null && ok "strapi reachable" || w "strapi not reachable"

echo ""
echo "======================================"
echo "RESULT"
echo "errors: $fail"
echo "warnings: $warn"
echo "======================================"
