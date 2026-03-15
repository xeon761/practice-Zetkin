#!/bin/bash
set -e

cd "$(dirname "$0")/.."

if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./backups"
mkdir -p "$BACKUP_DIR"

echo "Creating backup..."
docker compose exec -T postgres pg_dump -U ${PG_USER} ${PG_DB} > "$BACKUP_DIR/db_${DATE}.sql"

tar -czf "$BACKUP_DIR/backup_${DATE}.tar.gz" -C "$BACKUP_DIR" "db_${DATE}.sql"
rm "$BACKUP_DIR/db_${DATE}.sql"

find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +${KEEP_DAYS:-7} -delete

echo "Backup created: backup_${DATE}.tar.gz"
