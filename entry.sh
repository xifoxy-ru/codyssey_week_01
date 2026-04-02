#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd)"

OS_NAME="mac"
OS_VER="$(sw_vers -productVersion 2>/dev/null || echo 'unknown')"
SHELL_NAME="$(basename "${SHELL:-unknown}")"
DOCKER_VER="$(docker --version 2>/dev/null | sed -E 's/^Docker version ([0-9.]+).*/\1/' || echo 'not installed')"
GIT_VER="$(git --version 2>/dev/null | sed -E 's/^git version ([0-9.]+).*/\1/' || echo 'not installed')"

printf "실행 환경\n"
printf "os: %s %s\n" "$OS_NAME" "$OS_VER"
printf "shell: %s\n" "$SHELL_NAME"
printf "docker: %s\n" "$DOCKER_VER"
printf "git: %s\n\n" "$GIT_VER"

chmod +x "$BASE/cls.sh" \
    "$BASE/start.sh" >/dev/null 2>&1

chmod +x "$BASE/00_cli/cls_cli.sh" \
    "$BASE/00_cli/run_cli.sh" >/dev/null 2>&1

chmod +x "$BASE/01_permission/cls_permission.sh" \
    "$BASE/01_permission/run_permission.sh" >/dev/null 2>&1

chmod +x "$BASE/02_docker/00_run_docker_check.sh" \
    "$BASE/02_docker/01_run_custom_web.sh" \
    "$BASE/02_docker/02_run_volume_test.sh" \
    "$BASE/02_docker/cls_docker.sh" >/dev/null 2>&1