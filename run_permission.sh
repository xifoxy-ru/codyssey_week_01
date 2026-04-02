#!/bin/bash

BASE=~/__dev/codyssey_week_01
LOG="$BASE/permission_log"

mkdir -p "$BASE"
cd "$BASE" || exit 1
rm -f "$LOG"

YELLOW='\033[1;33m'
RESET='\033[0m'

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

FILE="$BASE/permission_test_file"
DIR="$BASE/permission_test_dir"

step "1단계: 권한 실습용 파일/디렉토리 생성"
echo "=== 권한 실습용 파일/디렉토리 생성 ===" >> "$LOG"
rm -rf "$FILE" "$DIR"
touch "$FILE"
mkdir -p "$DIR"
ls -ld "$FILE" "$DIR" >> "$LOG"
ls -ld "$FILE" "$DIR"
gap

step "2단계: 초기 권한 확인"
echo "=== 초기 권한 확인 ===" >> "$LOG"
stat -f "%Sp %N" "$FILE" "$DIR" >> "$LOG"
stat -f "%Sp %N" "$FILE" "$DIR"
gap

step "3단계: 파일 권한 600으로 변경"
echo "=== 파일 권한 600으로 변경 ===" >> "$LOG"
chmod 600 "$FILE"
stat -f "%Sp %N" "$FILE" >> "$LOG"
stat -f "%Sp %N" "$FILE"
gap

step "4단계: 파일 권한 644로 변경"
echo "=== 파일 권한 644로 변경 ===" >> "$LOG"
chmod 644 "$FILE"
stat -f "%Sp %N" "$FILE" >> "$LOG"
stat -f "%Sp %N" "$FILE"
gap

step "5단계: 디렉토리 권한 700으로 변경"
echo "=== 디렉토리 권한 700으로 변경 ===" >> "$LOG"
chmod 700 "$DIR"
stat -f "%Sp %N" "$DIR" >> "$LOG"
stat -f "%Sp %N" "$DIR"
gap

step "6단계: 디렉토리 권한 755로 변경"
echo "=== 디렉토리 권한 755로 변경 ===" >> "$LOG"
chmod 755 "$DIR"
stat -f "%Sp %N" "$DIR" >> "$LOG"
stat -f "%Sp %N" "$DIR"
gap

echo
printf "${YELLOW}모든 권한 실습이 끝났습니다.${RESET}\n"
printf "${YELLOW}결과 파일: %s${RESET}\n" "$LOG"