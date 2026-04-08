#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd -P)"
LOG="$BASE/bonus_demo_log"

cd "$BASE" || exit 1
: > "$LOG"

YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'

if [ -f "$BASE/.env" ]; then
  set -a
  . "$BASE/.env"
  set +a
fi

DB_NAME="${WORDPRESS_DB_NAME:-wordpress}"
DB_USER="${MYSQL_USER:-wpuser}"
DB_PASS="${MYSQL_PASSWORD:-wppass}"
DB_ROOT_PASS="${MYSQL_ROOT_PASSWORD:-rootpass}"
HOST_URL="http://localhost"

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

printf "\n"
printf "${CYAN}================== 04_BONUS DEMO ==================${RESET}\n"
printf '================== 04_BONUS DEMO ==================\n' >> "$LOG"

run_step "0단계: Docker Compose 서비스 상태 확인" \
  'docker compose ps'

run_step "0단계: Docker Compose 서비스 상태 확인" \
  'docker compose up -d'

run_step "2단계: Nginx/WordPress 메인 페이지 응답 헤더 확인" \
  'curl -I '"$HOST_URL"

run_step "3단계: WordPress 메인 페이지 일부 출력" \
  'curl -s '"$HOST_URL"' | head -n 20'

run_step "4단계: MariaDB 컨테이너 접속 확인" \
  'docker compose exec -T mariadb mariadb -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SELECT VERSION();"'

run_step "5단계: WordPress 데이터베이스 존재 확인" \
  "docker compose exec -T mariadb mariadb -uroot -p\"$MYSQL_ROOT_PASSWORD\" -e \"SHOW DATABASES LIKE '$DB_NAME';\""

run_step "6단계: WordPress 주요 테이블 존재 확인" \
  "docker compose exec -T mariadb mariadb -uroot -p\"$MYSQL_ROOT_PASSWORD\" \"$DB_NAME\" -e \"SHOW TABLES LIKE 'wp_options'; SHOW TABLES LIKE 'wp_users';\""

run_step "7단계: 사이트 주소(siteurl, home) 값 확인" \
  "docker compose exec -T mariadb mariadb -uroot -p\"$MYSQL_ROOT_PASSWORD\" \"$DB_NAME\" -e \"SELECT option_id, option_name, option_value FROM wp_options WHERE option_name IN ('siteurl','home');\""

run_step "8단계: 생성된 사용자 계정 확인" \
  "docker compose exec -T mariadb mariadb -uroot -p\"$MYSQL_ROOT_PASSWORD\" \"$DB_NAME\" -e \"SELECT ID, user_login, user_email, display_name, user_registered FROM wp_users;\""

run_step "9단계: 최근 WordPress 로그 확인" \
  'docker compose logs --tail=30 wordpress'

run_step "10단계: 최근 MariaDB 로그 확인" \
  'docker compose logs --tail=30 mariadb'

printf "${YELLOW}시연 점검이 끝났습니다.${RESET}\n"
printf "${YELLOW}로그 파일: %s${RESET}\n" "$LOG"