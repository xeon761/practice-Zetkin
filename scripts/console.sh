#!/bin/bash

cd "$(dirname "$0")/.."

if [ -z "$1" ]; then
    echo "Usage: $0 <service-name>"
    docker compose ps
    exit 1
fi

case $1 in
    postgres)
        docker compose exec "$1" psql -U ${PG_USER:-devuser} ${PG_DB:-strapi_dev}
        ;;
    *)
        docker compose exec "$1" sh
        ;;
esac
