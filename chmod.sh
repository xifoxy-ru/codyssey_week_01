#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd)"

chmod +x $BASE/cls.sh \
    $BASE/start.sh >/dev/null 2>&1

chmod +x $BASE/00_cli/cls_cli.sh \
    $BASE/00_cli/run_cli.sh >/dev/null 2>&1

chmod +x $BASE/01_permission/cls_permission.sh \
    $BASE/01_permission/run_permission.sh >/dev/null 2>&1

chmod +x $BASE/02_docker/00_run_docker_check.sh \
    $BASE/02_docker/01_run_custom_web.sh \
    $BASE/02_docker/02_run_volume_test.sh \
    $BASE/02_docker/cls_docker.sh >/dev/null 2>&1


