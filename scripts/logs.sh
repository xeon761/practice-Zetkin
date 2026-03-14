#!/bin/bash

cd "$(dirname "$0")/.."

if [ -z "$1" ]; then
    echo "Usage: $0 <service-name>"
    docker compose ps
    exit 1
fi

docker compose logs -f --tail=100 "$1"
