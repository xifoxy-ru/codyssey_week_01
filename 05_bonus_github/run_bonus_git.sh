#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd -P)"
LOG="$BASE/github_ssh_log"
ANSWER="$BASE/github_ssh_public_key.txt"
KEY_PATH="$HOME/.ssh/id_ed25519"

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

run_check_step() {
  local title="$1"
  local cmd="$2"
  local fail_msg="$3"

  step "$title"
  echo "=== $title ===" >> "$LOG"
  printf '$ %s\n' "$cmd" | tee -a "$LOG"

  if ! eval "$cmd" 2>&1 | tee -a "$LOG"; then
    echo
    printf "${YELLOW}%s${RESET}\n" "$fail_msg"
    exit 1
  fi

  printf "\n\n" >> "$LOG"
}

EMAIL="${1:-}"


printf "\n"
printf "${CYAN}================== 05_Bonus_GitHub_SSH ==================${RESET}\n"
printf '================== 05_Bonus_GitHub_SSH ==================\n' >> "$LOG"

if [ -z "$EMAIL" ]; then
  if [ -t 0 ]; then
    printf "${YELLOW}GitHub SSH 키에 사용할 이메일을 입력하세요: ${RESET}"
    read -r EMAIL
  else
    read -r EMAIL
  fi
fi

if [ -z "$EMAIL" ]; then
  echo "이메일이 비어 있습니다." | tee -a "$LOG"
  exit 1
fi

run_check_step "1단계: [git rev-parse --is-inside-work-tree] 현재 위치가 Git 저장소인지 확인" \
  'git rev-parse --is-inside-work-tree' \
  '현재 디렉토리가 Git 저장소가 아닙니다. 저장소 루트 또는 하위 디렉토리에서 다시 실행하세요.'

run_step "2단계: [git remote -v] 현재 Git 원격 저장소 확인" \
  'git remote -v || true'

run_step "3단계: [mkdir ~/.ssh && chmod 700] SSH 디렉터리 준비" \
  'mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"'

run_step "4단계: [ls -la ~/.ssh] 기존 SSH 키 존재 여부 확인" \
  'ls -la "$HOME/.ssh"'

if [ -f "$KEY_PATH" ] || [ -f "$KEY_PATH.pub" ]; then
  run_step "5단계: 기존 id_ed25519 키 존재 확인" \
    'echo "기존 키가 이미 존재합니다: '"$KEY_PATH"'"'
else
  run_check_step "5단계: [ssh-keygen -t ed25519] SSH 키 생성" \
    'ssh-keygen -t ed25519 -C "'"$EMAIL"'" -f "'"$KEY_PATH"'" -N ""' \
    'SSH 키 생성에 실패했습니다.'
fi

run_check_step "6단계: [ssh-agent 실행] 에이전트 시작" \
  'eval "$(ssh-agent -s)"' \
  'ssh-agent 실행에 실패했습니다.'

run_check_step "7단계: [ssh-add] SSH 개인키 등록" \
  'ssh-add "'"$KEY_PATH"'"' \
  'SSH 키 등록에 실패했습니다.'

run_check_step "8단계: [cat ~/.ssh/id_ed25519.pub] 공개키 출력 및 답안 파일 저장" \
  'cat "'"$KEY_PATH"'.pub" | tee "'"$ANSWER"'"' \
  '공개키 출력 또는 답안 파일 저장에 실패했습니다.'

run_check_step "9단계: [ssh-keygen -lf] 공개키 fingerprint 확인" \
  'ssh-keygen -lf "'"$KEY_PATH"'.pub"' \
  '공개키 fingerprint 확인에 실패했습니다.'

run_step "10단계: [ssh -T git@github.com] GitHub SSH 접속 테스트" \
  'ssh -T git@github.com 2>&1 || true'

run_step "11단계: [안내] GitHub SSH 테스트 결과 해석" \
  'echo "로그에 successfully authenticated 문구가 보이면 정상 연결입니다."'

run_step "12단계: [git remote get-url origin] origin 원격 저장소 확인 및 SSH URL 미리보기" \
  'REMOTE_URL="$(git remote get-url origin 2>/dev/null || true)"; \
   if [ -z "$REMOTE_URL" ]; then \
     echo "origin 원격 저장소가 없습니다."; \
   else \
     echo "현재 origin: $REMOTE_URL"; \
     if printf "%s" "$REMOTE_URL" | grep -q "^https://github.com/"; then \
       SSH_URL="$(printf "%s" "$REMOTE_URL" | sed '"'"'s#https://github.com/#git@github.com:#'"'"')"; \
       echo "변경 예정 SSH URL: $SSH_URL"; \
     elif printf "%s" "$REMOTE_URL" | grep -q "^git@github.com:"; then \
       echo "이미 SSH 방식입니다."; \
     else \
       echo "GitHub HTTPS 원격 저장소 형식이 아닙니다."; \
     fi; \
   fi'

step "13단계: [선택] origin 원격 저장소를 SSH 방식으로 변경"
echo "=== 13단계: [선택] origin 원격 저장소를 SSH 방식으로 변경 ===" >> "$LOG"
printf "${YELLOW}origin URL을 실제로 SSH 방식으로 변경할까요? [y/N]: ${RESET}"
read -r CHANGE_REMOTE
echo "입력값: ${CHANGE_REMOTE:-N}" | tee -a "$LOG"

if [[ "$CHANGE_REMOTE" =~ ^[Yy]$ ]]; then
  printf '$ %s\n' 'git remote set-url origin <ssh-url>' | tee -a "$LOG"
  REMOTE_URL="$(git remote get-url origin 2>/dev/null || true)"
  if [ -z "$REMOTE_URL" ]; then
    echo "origin 원격 저장소가 없어 변경하지 않습니다." | tee -a "$LOG"
  elif printf "%s" "$REMOTE_URL" | grep -q "^https://github.com/"; then
    SSH_URL="$(printf "%s" "$REMOTE_URL" | sed 's#https://github.com/#git@github.com:#')"
    git remote set-url origin "$SSH_URL" 2>&1 | tee -a "$LOG"
    echo "변경 완료: $SSH_URL" | tee -a "$LOG"
  elif printf "%s" "$REMOTE_URL" | grep -q "^git@github.com:"; then
    echo "이미 SSH 방식이라 변경할 필요가 없습니다." | tee -a "$LOG"
  else
    echo "GitHub HTTPS 원격 저장소가 아니므로 자동 변경하지 않습니다." | tee -a "$LOG"
  fi
else
  echo "origin URL 변경을 건너뜁니다." | tee -a "$LOG"
fi
printf "\n\n" >> "$LOG"

run_step "14단계: [git remote -v] 최종 원격 저장소 확인" \
  'git remote -v || true'

run_step "15단계: [git branch --show-current] 현재 브랜치 확인" \
  'git branch --show-current || true'

run_step "16단계: [git status --short] 작업 트리 상태 확인" \
  'git status --short || true'

run_step "17단계: 요약 정보 저장" \
  '{ \
    echo "=== summary ==="; \
    echo "email: '"$EMAIL"'"; \
    echo "private key: '"$KEY_PATH"'"; \
    echo "public key: '"$KEY_PATH"'.pub"; \
    echo "answer file: '"$ANSWER"'"; \
    echo; \
    echo "[public key]"; \
    cat "'"$KEY_PATH"'.pub"; \
    echo; \
    echo "[remote]"; \
    git remote -v || true; \
    echo; \
    echo "[branch]"; \
    git branch --show-current || true; \
    echo; \
    echo "[status]"; \
    git status --short || true; \
  } | tee -a "'"$LOG"'"'

echo
printf "${YELLOW}GitHub SSH 설정 점검이 끝났습니다.${RESET}\n"
printf "${YELLOW}로그 파일: %s${RESET}\n" "$LOG"
printf "${YELLOW}답안 파일(공개키): %s${RESET}\n" "$ANSWER"
printf "${YELLOW}이제 공개키를 GitHub > Settings > SSH and GPG keys 에 등록하면 됩니다.${RESET}\n"