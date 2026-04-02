#!/bin/bash

BASE=~/__dev/codyssey_week_01/01_permission
LOG="$BASE/permission_log"

mkdir -p "$BASE"
cd "$BASE" || exit 1
: > "$LOG"

YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'

FILE="$BASE/permission_test_file"
DIR="$BASE/permission_test_dir"

step() {
  echo
  printf "${YELLOW}======================================${RESET}\n"
  printf "${YELLOW}%s${RESET}\n" "$1"
  printf "${YELLOW}엔터를 누르면 실행됩니다.${RESET}\n"
  read
}

run_step() {
  local title="$1"
  local cmd="$2"

  step "$title"
  echo "=== $title ===" >> "$LOG"
  printf '$ %s\n' "$cmd" | tee -a "$LOG"
  eval "$cmd" 2>&1 | tee -a "$LOG"
  printf "\n\n" >> "$LOG"
}

printf "\n\n"
printf "${CYAN}================== 01_Permission${RESET}\n"
printf '================== 01_Permission$\n' >> "$LOG"

run_step "1단계: [touch, mkdir, ls -ld] 권한 실습용 파일/디렉토리 생성" \
  'touch "$FILE" && mkdir -p "$DIR" && ls -ld "$FILE" "$DIR"'

run_step "2단계: [stat -f] 초기 권한 확인" \
  'stat -f "%Sp %N" "$FILE" "$DIR"'

run_step "3단계: [chmod 600] 파일 권한 600으로 변경" \
  'chmod 600 "$FILE" && stat -f "%Sp %N" "$FILE"'

run_step "4단계: [chmod 644] 파일 권한 644로 변경" \
  'chmod 644 "$FILE" && stat -f "%Sp %N" "$FILE"'

run_step "5단계: [chmod 700] 디렉토리 권한 700으로 변경" \
  'chmod 700 "$DIR" && stat -f "%Sp %N" "$DIR"'

run_step "6단계: [chmod 755] 디렉토리 권한 755로 변경" \
  'chmod 755 "$DIR" && stat -f "%Sp %N" "$DIR"'

echo
printf "${YELLOW}모든 권한 실습이 끝났습니다.${RESET}\n"
printf "${YELLOW}결과 파일: %s${RESET}\n" "$LOG"