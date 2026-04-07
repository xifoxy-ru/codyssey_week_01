#!/bin/bash
set -e

BASE="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE"

sh $BASE/00_cli/run_cli.sh
sh $BASE/01_permission/run_permission.sh
sh $BASE/02_docker/00_run_docker_check.sh
sh $BASE/02_docker/01_run_custom_web.sh
sh $BASE/02_docker/02_run_volume_test.sh
sh $BASE/03_github/run_git.sh