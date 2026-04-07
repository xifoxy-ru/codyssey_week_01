#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$BASE/.." && pwd)"
LOG="$BASE/github_log"

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

printf "\n\n"
printf "${CYAN}================== 03_github${RESET}\n"
printf '================== 03_github$\n' > "$LOG"

run_step "1단계: [git config --global user.name] Git 사용자 이름 확인" \
  'git config --global user.name || echo "user.name not set"'

run_step "2단계: [git config --global user.email] Git 사용자 이메일 확인" \
  'git config --global user.email || echo "user.email not set"'

run_step "3단계: [git config --global init.defaultBranch] 기본 브랜치 확인" \
  'git config --global init.defaultBranch || echo "init.defaultBranch not set"'

run_step "4단계: [git config --list] 전체 Git 설정 확인" \
  'git config --list'

run_step "5단계: [git config --list | grep remote] 원격 저장소 연결 주소 확인" \
  'git config --list | grep remote || true'

printf "${YELLOW}Git/GitHub 점검이 끝났습니다.${RESET}\n"
printf "${YELLOW}결과 파일: %s${RESET}\n" "$LOG"