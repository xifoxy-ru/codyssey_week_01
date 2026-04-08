#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd -P)"
cd "$BASE"

sh $BASE/04_bonus_compose/run_bonus_compose.sh
sh $BASE/04_bonus_github/run_bonus_git.sh