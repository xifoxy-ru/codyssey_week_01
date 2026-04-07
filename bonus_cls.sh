#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE"

sh $BASE/04_bonus_compose/cls_bonus_compose.sh
sh $BASE/05_bonus_github/cls_bonus_git.sh