#!/bin/bash
set -e

cd "$(dirname "$0")/.."

echo "Updating..."

if [ -d ".git" ]; then
    git pull origin develop || echo "Git pull skipped"
fi

./scripts/backup.sh

docker compose build --no-cache astro strapi
docker compose up -d --force-recreate astro strapi

sleep 20
echo "Update complete"
