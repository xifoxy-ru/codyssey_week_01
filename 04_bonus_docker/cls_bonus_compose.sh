#!/bin/bash
BASE="$(cd "$(dirname "$0")" && pwd)"

rm -f bonus_demo_log
docker comopsoe down -v >/dev/null 2>&1
docker rm -f $(docker ps -aq) >/dev/null 2>&1
docker rmi -f $(docker images -q) >/dev/null 2>&1