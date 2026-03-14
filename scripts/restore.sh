#!/bin/bash
set -e

cd "$(dirname "$0")/.."

if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

BACKUP_DIR="./backups"
LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "Error: No backups found"
    exit 1
fi

echo "Found backup: $LATEST_BACKUP"
read -p "Continue? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 0
fi

docker compose down

TEMP_DIR=$(mktemp -d)
tar -xzf "$LATEST_BACKUP" -C "$TEMP_DIR"

docker compose up -d postgres
sleep 10

DB_DUMP=$(find "$TEMP_DIR" -name "db_*.sql" | head -1)
if [ -n "$DB_DUMP" ]; then
    cat "$DB_DUMP" | docker compose exec -T postgres psql -U ${PG_USER} ${PG_DB}
    echo "Database restored"
fi

rm -rf "$TEMP_DIR"
docker compose up -d

echo "Restore complete"
