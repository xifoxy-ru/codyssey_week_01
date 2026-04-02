#!/bin/bash
set -e

BASE=~/__dev/codyssey_week_01/02_docker
LOG="$BASE/volume_test_log"

VOLUME_NAME="codyssey-data"
CONTAINER_ONE="vol-test"
CONTAINER_TWO="vol-test2"

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
printf "${CYAN}================== 02_2-Volume${RESET}\n"
printf '================== 02_2-Volume$\n' >> "$LOG"

run_step "1단계: [docker rm -f + docker volume rm] 기존 테스트 흔적 정리" \
  'docker rm -f "$CONTAINER_ONE" >/dev/null 2>&1 || true; docker rm -f "$CONTAINER_TWO" >/dev/null 2>&1 || true; docker volume rm "$VOLUME_NAME" >/dev/null 2>&1 || true; echo "old containers removed"; echo "old volume removed if existed"'

run_step "2단계: [docker volume create] Docker 볼륨 생성" \
  'docker volume create "$VOLUME_NAME"'

run_step "3단계: [docker run -d --name vol-test -v codyssey-data:/data ubuntu sleep infinity] 첫 번째 컨테이너 실행" \
  'docker run -d --name "$CONTAINER_ONE" -v "$VOLUME_NAME:/data" ubuntu sleep infinity'

run_step "4단계: [docker exec vol-test bash -lc] 볼륨에 데이터 저장" \
  'docker exec "$CONTAINER_ONE" bash -lc "echo hi > /data/hello.txt && cat /data/hello.txt"'

run_step "5단계: [docker rm -f vol-test] 첫 번째 컨테이너 삭제" \
  'docker rm -f "$CONTAINER_ONE"'

run_step "6단계: [docker run -d --name vol-test2 -v codyssey-data:/data ubuntu sleep infinity] 두 번째 컨테이너 실행" \
  'docker run -d --name "$CONTAINER_TWO" -v "$VOLUME_NAME:/data" ubuntu sleep infinity'

run_step "7단계: [docker exec vol-test2 bash -lc] 데이터 유지 여부 확인" \
  'docker exec "$CONTAINER_TWO" bash -lc "cat /data/hello.txt"'

run_step "8단계: [docker volume ls] 볼륨 목록 확인" \
  'docker volume ls'

echo
printf "${YELLOW}볼륨 영속성 검증이 끝났습니다.${RESET}\n"
printf "${YELLOW}결과 파일: %s${RESET}\n" "$LOG"
printf "${YELLOW}유지 확인 컨테이너: %s${RESET}\n" "$CONTAINER_TWO"