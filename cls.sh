#!/bin/bash
set -e

BASE="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE"

sh $BASE/00_cli/cls_cli.sh
sh $BASE/01_permission/cls_permission.sh
sh $BASE/02_docker/cls_docker.sh