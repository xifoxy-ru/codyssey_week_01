#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd -P)"

cd "$BASE" || exit 1

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
  echo "=== $title ==="
  printf '$ %s\n' "$cmd" | tee
  eval "$cmd" 2>&1 | tee
  printf "\n\n"
}

printf "\n"
printf "${CYAN}================== GitHub HTTPS Restore ==================${RESET}\n"
printf '================== GitHub HTTPS Restore ==================\n'

run_step "1단계: 현재 origin 확인" \
  'git remote -v || true'

run_step "2단계: origin 주소를 SSH에서 HTTPS로 변환" \
  'REMOTE_URL="$(git remote get-url origin 2>/dev/null || true)"; \
   if [ -z "$REMOTE_URL" ]; then \
     echo "origin 원격 저장소가 없습니다."; \
   elif printf "%s" "$REMOTE_URL" | grep -q "^git@github.com:"; then \
     HTTPS_URL="$(printf "%s" "$REMOTE_URL" | sed '"'"'s#git@github.com:#https://github.com/#'"'"')"; \
     git remote set-url origin "$HTTPS_URL"; \
     echo "변경 완료: $HTTPS_URL"; \
   elif printf "%s" "$REMOTE_URL" | grep -q "^https://github.com/"; then \
     echo "이미 HTTPS 방식입니다."; \
   else \
     echo "GitHub SSH 형식이 아니므로 자동 변경하지 않습니다."; \
   fi'

run_step "3단계: 변경된 origin 확인" \
  'git remote -v || true'

echo

rm -f github_ssh_log
rm -f github_ssh_public_key
rm -f ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.pub
ssh-add -D

printf "${YELLOW}HTTPS 복구가 끝났습니다.${RESET}\n"