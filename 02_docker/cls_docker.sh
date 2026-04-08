#!/bin/bash
BASE="$(cd "$(dirname "$0")" && pwd -P)"

rm -f "$BASE/docker_check_log" \
    "$BASE/custom_web_log" \
    "$BASE/volume_test_log" >/dev/null 2>&1

docker rm -f $(docker ps -aq) >/dev/null 2>&1
docker rmi -f $(docker images -q) >/dev/null 2>&1

perl -0pi -e "s/Bind Mount Updated/Custom NGINX Container/g" "$BASE/web/site/index.html"