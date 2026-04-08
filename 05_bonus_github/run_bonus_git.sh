#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd -P)"
LOG="$BASE/github_ssh_log"
ANSWER="$BASE/__answer"

mkdir -p "$BASE"
cd "$BASE" || exit 1

: > "$LOG"
: > "$ANSWER"

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

EMAIL=""
KEY_PATH="$HOME/.ssh/id_ed25519"

if [ -t 0 ]; then
  printf "${YELLOW}GitHub SSH 키에 사용할 이메일을 입력하세요: ${RESET}"
  read -r EMAIL
else
  read -r EMAIL
fi

if [ -z "$EMAIL" ]; then
  echo "이메일이 비어 있습니다." | tee -a "$LOG"
  exit 1
fi

printf "\n"
printf "${CYAN}================== GitHub SSH Setup ==================${RESET}\n"
printf '================== GitHub SSH Setup ==================\n' >> "$LOG"

run_step "1단계: 현재 Git 원격 저장소 확인" \
  'git remote -v || true'

run_step "2단계: ~/.ssh 디렉터리 생성" \
  'mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"'

run_step "3단계: 기존 SSH 키 존재 여부 확인" \
  'ls -la "$HOME/.ssh"'

if [ -f "$KEY_PATH" ] || [ -f "$KEY_PATH.pub" ]; then
  run_step "4단계: 기존 id_ed25519 키 존재 확인" \
    'echo "기존 키가 이미 존재합니다: '"$KEY_PATH"'"'
else
  run_step "4단계: ed25519 SSH 키 생성" \
    'ssh-keygen -t ed25519 -C "'"$EMAIL"'" -f "'"$KEY_PATH"'" -N ""'
fi

run_step "5단계: ssh-agent 실행" \
  'eval "$(ssh-agent -s)"'

run_step "6단계: SSH 개인키 등록" \
  'ssh-add "'"$KEY_PATH"'"'

run_step "7단계: 공개키 내용 출력 및 답안 파일 저장" \
  'cat "'"$KEY_PATH"'.pub" | tee "'"$ANSWER"'"'

run_step "8단계: 공개키 fingerprint 확인" \
  'ssh-keygen -lf "'"$KEY_PATH"'.pub"'

run_step "9단계: GitHub SSH 접속 테스트(처음 연결 시 yes 입력 가능)" \
  'ssh -T git@github.com || true'

run_step "10단계: origin 원격 저장소를 SSH 방식으로 바꿀 수 있는지 확인" \
  'REMOTE_URL="$(git remote get-url origin 2>/dev/null || true)"; \
   if [ -z "$REMOTE_URL" ]; then \
     echo "origin 원격 저장소가 없습니다."; \
   else \
     echo "현재 origin: $REMOTE_URL"; \
     if printf "%s" "$REMOTE_URL" | grep -q "^https://github.com/"; then \
       SSH_URL="$(printf "%s" "$REMOTE_URL" | sed '"'"'s#https://github.com/#git@github.com:#'"'"')"; \
       echo "변경될 SSH URL: $SSH_URL"; \
     elif printf "%s" "$REMOTE_URL" | grep -q "^git@github.com:"; then \
       echo "이미 SSH 방식입니다."; \
     else \
       echo "GitHub HTTPS 원격 저장소 형식이 아닙니다."; \
     fi; \
   fi'

run_step "11단계: origin 원격 저장소를 SSH 방식으로 변경" \
  'REMOTE_URL="$(git remote get-url origin 2>/dev/null || true)"; \
   if [ -z "$REMOTE_URL" ]; then \
     echo "origin 원격 저장소가 없어 변경하지 않습니다."; \
   elif printf "%s" "$REMOTE_URL" | grep -q "^https://github.com/"; then \
     SSH_URL="$(printf "%s" "$REMOTE_URL" | sed '"'"'s#https://github.com/#git@github.com:#'"'"')"; \
     git remote set-url origin "$SSH_URL"; \
     echo "변경 완료: $SSH_URL"; \
   elif printf "%s" "$REMOTE_URL" | grep -q "^git@github.com:"; then \
     echo "이미 SSH 방식이라 변경할 필요가 없습니다."; \
   else \
     echo "GitHub HTTPS 원격 저장소가 아니므로 자동 변경하지 않습니다."; \
   fi'

run_step "12단계: 변경된 원격 저장소 확인" \
  'git remote -v || true'

run_step "13단계: 요약 정보 저장" \
  '{ \
    echo "=== summary ==="; \
    echo "email: '"$EMAIL"'"; \
    echo "private key: '"$KEY_PATH"'"; \
    echo "public key: '"$KEY_PATH"'.pub"; \
    echo; \
    echo "[public key]"; \
    cat "'"$KEY_PATH"'.pub"; \
    echo; \
    echo "[remote]"; \
    git remote -v || true; \
  } | tee -a "'"$LOG"'"'

echo
printf "${YELLOW}GitHub SSH 설정 점검이 끝났습니다.${RESET}\n"
printf "${YELLOW}로그 파일: %s${RESET}\n" "$LOG"
printf "${YELLOW}답안 파일(공개키): %s${RESET}\n" "$ANSWER"
printf "${YELLOW}이제 __answer 내용을 GitHub > Settings > SSH and GPG keys 에 등록하세요.${RESET}\n"