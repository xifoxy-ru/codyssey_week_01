#!/bin/bash
set -e

BASE=~/__dev/codyssey_week_01/02_docker
WEB_DIR="$BASE/web"
LOG="$BASE/custom_web_log"

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
printf "${CYAN}================== 02_1-Custom-Web${RESET}\n"
printf '================== 02_1-Custom-Web$\n' >> "$LOG"

run_step "1단계: [docker build -t codyssey-custom-web:1.0] 커스텀 이미지 빌드" \
  'docker build -t codyssey-custom-web:1.0 "$WEB_DIR"'

run_step "2단계: [docker run -d -p 8080:80] 포트 매핑으로 실행" \
  'docker rm -f codyssey-web-8080 >/dev/null 2>&1; docker run -d -p 8080:80 --name codyssey-web-8080 codyssey-custom-web:1.0'

run_step "3단계: [curl http://localhost:8080] 접속 확인" \
  'curl http://localhost:8080'

run_step "4단계: [docker run -d -p 8081:80 -v ...] 바인드 마운트 컨테이너 실행" \
  'docker rm -f codyssey-web-bind >/dev/null 2>&1; docker run -d -p 8081:80 -v "$WEB_DIR/site:/usr/share/nginx/html" --name codyssey-web-bind nginx:alpine'

run_step "5단계: [curl http://localhost:8081] 바인드 마운트 접속 확인" \
  'curl http://localhost:8081'

echo
printf "${YELLOW}커스텀 웹 서버 단계가 끝났습니다.${RESET}\n"
printf "${YELLOW}결과 파일: %s${RESET}\n" "$LOG"
printf "${YELLOW}브라우저 확인 주소: http://localhost:8080 , http://localhost:8081${RESET}\n"