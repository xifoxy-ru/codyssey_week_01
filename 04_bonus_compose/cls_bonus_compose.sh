#!/bin/bash
BASE="$(cd "$(dirname "$0")" && pwd -P)"

rm -f "$BASE/bonus_demo_log"
docker compose down -v >/dev/null 2>&1
docker rm -f $(docker ps -aq) >/dev/null 2>&1
docker rmi -f $(docker images -q) >/dev/null 2>&1
VOLUMES="$(docker volume ls -q)"
[ -n "$VOLUMES" ] && docker volume rm $VOLUMES >/dev/null 2>&1