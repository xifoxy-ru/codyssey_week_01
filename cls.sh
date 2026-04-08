#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd -P)"
cd "$BASE"

sh $BASE/00_cli/cls_cli.sh
sh $BASE/01_permission/cls_permission.sh
sh $BASE/02_docker/cls_docker.sh
sh $BASE/03_github/cls_github.sh