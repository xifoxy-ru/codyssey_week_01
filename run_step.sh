#!/bin/bash

LOG=~/__dev/codyssey_week_01/terminal_cli
BASE=~/__dev/codyssey_week_01

mkdir -p "$BASE"
cd "$BASE" || exit 1
touch "$LOG"

YELLOW='\033[1;33m'
RESET='\033[0m'

rm -rf "$BASE"/answer_directory
rm -f "$BASE"/terminal_cli

step() {
  echo
  printf "${YELLOW}======================================${RESET}\n"
  printf "${YELLOW}%s${RESET}\n" "$1"
  printf "${YELLOW}엔터를 누르면 실행됩니다.${RESET}\n"
  read
}

gap() {
  printf "\n\n" >> "$LOG"
}

step "1단계: pwd 현재 위치"
echo "=== pwd 현재 위치 ===" >> "$LOG"
pwd >> "$LOG"
pwd
gap

step "2단계: mkdir 파일생성"
echo "=== mkdir 파일생성 ===" >> "$LOG"
mkdir -p "$BASE/answer_directory"
ls -la "$BASE" | grep answer_directory >> "$LOG"
ls -la "$BASE" | grep answer_directory
gap

step "3단계: ls -la 모든 파일 목록"
echo "=== ls -la 모든 파일 목록 ===" >> "$LOG"
ls -la "$BASE" >> "$LOG"
ls -la "$BASE"
gap

step "4단계: touch test 결과"
echo "=== touch 결과 ===" >> "$LOG"
touch "$BASE/test"
ls -la "$BASE/test" >> "$LOG"
ls -la "$BASE/test"
gap

step "5단계: cp test test_copy 결과"
echo "=== cp test test_copy 결과 ===" >> "$LOG"
cp "$BASE/test" "$BASE/test_copy"
ls -la "$BASE/" | grep test >> "$LOG"
ls -la "$BASE/" | grep test
gap

step "6단계: mv test_copy test_renamed 결과"
echo "=== mv test_copy test_renamed 결과 ===" >> "$LOG"
mv "$BASE/test_copy" "$BASE/test_renamed"
ls -la "$BASE/" | grep test >> "$LOG"
ls -la "$BASE/" | grep test
gap

step "7단계: rm test_renamed test 후 목록"
echo "=== rm 후 목록 ===" >> "$LOG"
rm "$BASE/test_renamed" "$BASE/test"
ls -la "$BASE/" >> "$LOG"
ls -la "$BASE/"
gap

step "8단계: cat terminal_cli 결과"
echo "=== cat terminal_cli 결과 ===" >> "$LOG"
echo "이미 다 출력 했기에 생략" >> "$LOG"
cat "$LOG"
gap

echo
printf "${YELLOW}모든 단계가 끝났습니다.${RESET}\n"
printf "${YELLOW}결과 파일: %s${RESET}\n" "$LOG"