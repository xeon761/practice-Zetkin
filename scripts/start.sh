#!/bin/bash
set -e

cd "$(dirname "$0")/.."

if [ ! -f ".env" ]; then
    echo "Error: .env not found. Copy .env.example and edit it."
    exit 1
fi

echo "Starting services..."
docker compose down --remove-orphans 2>/dev/null || true
docker compose up -d --build --scale astro=2 --scale strapi=2

sleep 20

echo ""
echo "Services up!"
echo "Frontend: http://localhost"
echo "Strapi: http://localhost/admin"
echo "pgAdmin: http://localhost:5050"
echo "HAproxy Stats: http://localhost:8404/stats"
