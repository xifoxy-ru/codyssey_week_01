#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd -P)"
LOG="$BASE/cli_log"

mkdir -p "$BASE"
cd "$BASE" || exit 1
: > "$LOG"

YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'

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

printf "\n${CYAN}================== 00_CLI${RESET}\n"
echo "================== 00_CLI$" >> "$LOG"

run_step "1단계: [pwd] 현재 위치" 'pwd'
run_step "2단계: [mkdir answer_directory] 폴더 생성" \
  'mkdir -p "$BASE/answer_directory" && ls -la "$BASE" | grep answer_directory'
run_step "3단계: [ls -la] 모든 파일 목록" 'ls -la "$BASE"'
run_step "4단계: [touch test] 빈 파일 생성" \
  'touch "$BASE/test" && ls -la "$BASE/test"'
run_step "5단계: [cp test test_copy] 복사" \
  'cp "$BASE/test" "$BASE/test_copy" && ls -la "$BASE" | grep test'
run_step "6단계: [mv test_copy test_renamed] 이름 변경 혹은 이동" \
  'mv "$BASE/test_copy" "$BASE/test_renamed" && ls -la "$BASE" | grep test'
run_step "7단계: [rm test_renamed test] 삭제" \
  'rm -f "$BASE/test_renamed" "$BASE/test" && ls -la "$BASE"'

step "8단계: [cat cli_log] 파일 내용 출력"
echo "=== 8단계: [cat cli_log] 파일 내용 출력 ===" >> "$LOG"
echo "화면 길어짐으로 생략" >> "$LOG"
cat cli_log

printf "${YELLOW}모든 단계가 끝났습니다.${RESET}\n"
printf "${YELLOW}결과 파일: %s${RESET}\n" "$LOG"