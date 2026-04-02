#!/bin/bash

BASE=~/__dev/codyssey_week_01/02_docker
LOG="$BASE/docker_check_log"

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

printf "\n\n"
printf "${CYAN}================== 02_0-Docker${RESET}\n"
printf '================== 02_0-Docker$\n' >> "$LOG"

run_step "1단계: [docker --version] Docker 버전 확인" \
  'docker --version'

run_check_step "2단계: [docker info] Docker 데몬 정보 확인" \
  'docker info' \
  'docker info 실행에 실패했습니다. OrbStack이 실행 중인지 먼저 확인하세요.'

run_step "3단계: [docker run hello-world] hello-world 실행" \
  'docker rm -f hello-world-test >/dev/null 2>&1; docker run --name hello-world-test hello-world'

run_step "4단계: [docker images] 이미지 목록 확인" \
  'docker images'

run_step "5단계: [docker pull ubuntu] ubuntu 이미지 다운로드" \
  'docker pull ubuntu'

run_step "6단계: [docker run -dit --name ubuntu-cli-test ubuntu bash] ubuntu 컨테이너 생성 및 실행" \
  'docker rm -f ubuntu-cli-test >/dev/null 2>&1; docker run -dit --name ubuntu-cli-test ubuntu bash'

run_step "7단계: [docker ps] 실행 중인 컨테이너 목록 확인" \
  'docker ps'

run_step "8단계: [docker ps -a] 전체 컨테이너 목록 확인" \
  'docker ps -a'

run_step "9단계: [docker exec ubuntu-cli-test bash -lc] ubuntu 컨테이너 내부 명령 실행" \
  'docker exec ubuntu-cli-test bash -lc "ls; echo '\''hello from ubuntu container'\''; pwd"'

run_step "10단계: [docker logs hello-world-test] hello-world 로그 확인" \
  'docker logs hello-world-test'

run_step "11단계: [docker run -d --name ubuntu-stats ubuntu sleep infinity] stats 확인용 컨테이너 실행" \
  'docker rm -f ubuntu-stats >/dev/null 2>&1; docker run -d --name ubuntu-stats ubuntu sleep infinity'

run_step "12단계: [docker stats --no-stream ubuntu-stats] 리소스 사용량 확인" \
  'docker stats --no-stream ubuntu-stats'

run_step "13단계: [docker stop + docker ps -a] 컨테이너 종료 후 전체 목록 확인" \
  'docker stop ubuntu-stats >/dev/null 2>&1; docker stop ubuntu-cli-test >/dev/null 2>&1; docker ps -a'

echo
printf "${YELLOW}Docker 점검 단계가 끝났습니다.${RESET}\n"
printf "${YELLOW}결과 파일: %s${RESET}\n" "$LOG"