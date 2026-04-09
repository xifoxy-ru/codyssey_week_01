# 개발 워크스테이션 구축 미션

> 이 문서는 프로젝트 루트 디렉토리에서 작업한 내용을 기준으로 정리하였다.  
> 본 문서는 **터미널 기본 조작**, **파일 권한 실습**, **Docker 기본 점검 및 실습**, **Git/GitHub 연동**, 그리고 **Bonus 항목(Docker Compose, GitHub SSH)** 까지 포함하여 재현 가능한 형태로 정리하는 것을 목표로 한다.

---

## 1. 프로젝트 개요

이 과제의 목표는 터미널, Docker, Git/GitHub를 활용하여 개발 워크스테이션 환경을 직접 구성하고, 그 과정과 결과를 기술 문서 형태로 정리하는 것이다.

이번 미션에서는 다음 항목을 중심으로 작업을 진행하였다.

- 터미널로 작업 디렉토리 및 파일을 다루는 기본 조작 수행
- 파일과 디렉토리의 권한 확인 및 변경 실습
- Docker 설치 및 데몬 동작 여부 점검
- hello-world 및 ubuntu 컨테이너 실행과 기본 운영 명령 확인
- Dockerfile 기반 커스텀 이미지 제작
- 포트 매핑을 통한 브라우저 접속 확인
- 바인드 마운트로 호스트 변경 사항이 컨테이너에 즉시 반영되는지 검증
- Docker 볼륨을 이용한 데이터 영속성 확인
- Git 사용자 설정 및 원격 저장소 연결 상태 확인
- Bonus: Docker Compose 기반 다중 컨테이너 구성
- Bonus: GitHub SSH 키 생성 및 SSH 방식 원격 저장소 전환 점검

---

## 2. 실행 환경

- OS: macOS
- Shell: zsh
- Terminal: iTerm2 또는 macOS Terminal
- Docker: OrbStack 기반 Docker 환경 사용
- Git: 로컬 Git 설치 환경 사용

버전 확인 명령:

```bash
sw_vers -productVersion
echo "$(basename "${SHELL:-unknown}")"
docker --version
git --version
```

실행 결과 기록 예시:

```bash
os: mac 15.7.4
shell: zsh
docker: 28.5.2
git: 2.53.0
```

> 전체 실행 진입점으로 `entry.sh` 와 `start.sh` 를 둘 수 있지만, 제출 검증은 각 단계별 `run_*.sh` 스크립트 기준으로 정리하였다.

---

## 3. 수행 체크리스트

- [x] 터미널 기본 조작 및 폴더 구성
- [x] 파일 권한 실습
- [x] Docker 설치 및 기본 점검
- [x] hello-world 실행
- [x] ubuntu 컨테이너 실행 및 내부 명령 확인
- [x] Docker 기본 운영 명령 확인
- [x] Dockerfile 기반 커스텀 이미지 제작
- [x] 포트 매핑 검증
- [x] 바인드 마운트 검증
- [x] 볼륨 영속성 검증
- [x] Git 설정 확인
- [x] GitHub / VS Code 연동 확인
- [x] 트러블슈팅 2건 이상 정리
- [x] Bonus: Docker Compose
- [x] Bonus: GitHub SSH

---

## 4. 프로젝트 구조

```bash
.
├── 00_cli
│   └── run_cli.sh
├── 01_permission
│   └── run_permission.sh
├── 02_docker
│   ├── 00_run_docker_check.sh
│   ├── 01_run_custom_web.sh
│   ├── 02_run_volume_test.sh
│   └── web
│       ├── Dockerfile
│       └── site
│           └── index.html
├── 03_github
│   └── run_git.sh
├── 04_bonus_compose
│   ├── compose.yaml
│   ├── run_bonus_compose.sh
│   ├── .env
│   └── nginx
│       └── default.conf
└── 05_bonus_github
    └── run_bonus_git.sh
```

---

## 5. 실행 방법

각 단계는 개별 실행이 가능하도록 구성하였다.  
필요한 스크립트에 실행 권한을 부여한 뒤, 원하는 단계만 직접 실행하여 결과를 확인할 수 있다.

예시:

```bash
chmod +x 00_cli/run_cli.sh
./00_cli/run_cli.sh
```

모든 스크립트는 실행 결과를 별도의 로그 파일로 남기도록 구성하였다.

---

## 6. 00_CLI: 터미널 기본 조작

### 6-1. 사용 스크립트

- `00_cli/run_cli.sh`

### 6-2. 목적

터미널에서 가장 기본적인 파일 및 디렉토리 조작 명령을 직접 수행하고, 결과를 로그 파일로 남기는 것을 목표로 하였다.

### 6-3. 실행 방법

```bash
chmod +x 00_cli/run_cli.sh
./00_cli/run_cli.sh
```

실행 결과는 아래 파일에 기록된다.

```bash
00_cli/cli_log
```

### 6-4. 수행 명령 및 예상 출력

#### 6-4-1. 현재 위치 확인

```bash
pwd
```

예상 출력:

```bash
<프로젝트>/00_cli
```

예시:

```bash
$BASE_DIRECTORY/00_cli
```

> `run_cli.sh` 내부에서 `BASE="$(cd "$(dirname "$0")" && pwd -P)"` 와 `cd "$BASE"` 를 수행하므로, `pwd` 결과는 항상 `run_cli.sh` 가 위치한 디렉토리 기준으로 맞춰진다.

---

#### 6-4-2. 작업 디렉토리 생성

```bash
mkdir -p "$BASE/answer_directory"
ls -la "$BASE" | grep answer_directory
```

예상 출력:

```bash
drwxr-xr-x  ... answer_directory
```

---

#### 6-4-3. 전체 파일 목록 확인

```bash
ls -la "$BASE"
```

예상 출력:

```bash
.
..
answer_directory
cli_log
```

---

#### 6-4-4. 빈 파일 생성

```bash
touch "$BASE/test"
ls -la "$BASE/test"
```

예상 출력:

```bash
-rw-r--r--  ... test
```

---

#### 6-4-5. 파일 복사

```bash
cp "$BASE/test" "$BASE/test_copy"
ls -la "$BASE" | grep test
```

예상 출력:

```bash
-rw-r--r--  ... test
-rw-r--r--  ... test_copy
```

---

#### 6-4-6. 파일 이름 변경

```bash
mv "$BASE/test_copy" "$BASE/test_renamed"
ls -la "$BASE" | grep test
```

예상 출력:

```bash
-rw-r--r--  ... test
-rw-r--r--  ... test_renamed
```

---

#### 6-4-7. 파일 삭제 후 목록 확인

```bash
rm -f "$BASE/test_renamed" "$BASE/test"
ls -la "$BASE"
```

예상 출력:

```bash
.
..
answer_directory
cli_log
```

---

#### 6-4-8. 로그 파일 내용 확인

```bash
cat 00_cli/cli_log
```

예상 출력:

```bash
=== 1단계: [pwd] 현재 위치 ===
$ pwd
/Users/사용자이름/__dev/codyssey_week_01/00_cli

=== 2단계: [mkdir answer_directory] 폴더 생성 ===
$ mkdir -p "$BASE/answer_directory" && ls -la "$BASE" | grep answer_directory
drwxr-xr-x ... answer_directory
```

> 실제 로그에는 각 단계의 명령과 출력 결과가 순서대로 누적된다.

### 6-5. 검증 포인트

- `pwd` 결과가 `00_cli` 디렉토리 기준으로 출력되는지 확인
- `answer_directory` 생성 여부를 확인
- 파일 생성, 복사, 이름 변경, 삭제가 단계별로 반영되는지 확인
- 명령어와 출력 결과가 `cli_log`에 누적되는지 확인

---

## 7. 01_Permission: 파일 권한 실습

### 7-1. 사용 스크립트

- `01_permission/run_permission.sh`

### 7-2. 목적

파일 1개와 디렉토리 1개를 대상으로 권한을 변경하고, 변경 전후 차이를 확인하는 것을 목표로 하였다.

### 7-3. 실행 방법

```bash
chmod +x 01_permission/run_permission.sh
./01_permission/run_permission.sh
```

실행 결과는 아래 파일에 기록된다.

```bash
01_permission/permission_log
```

### 7-4. 수행 명령 및 예상 출력

#### 7-4-1. 실습용 파일/디렉토리 생성

```bash
touch $BASE_DIRECTORY/01_permission/permission_test_file
mkdir -p $BASE_DIRECTORY/01_permission/permission_test_dir
ls -ld $BASE_DIRECTORY/01_permission/permission_test_file $BASE_DIRECTORY/01_permission/permission_test_dir
```

예시 출력:

```bash
-rw-r--r--  ... $BASE_DIRECTORY/01_permission/permission_test_file
drwxr-xr-x  ... $BASE_DIRECTORY/01_permission/permission_test_dir
```

---

#### 7-4-2. 초기 권한 확인

```bash
stat -f "%Sp %N" $BASE_DIRECTORY/01_permission/permission_test_file $BASE_DIRECTORY/01_permission/permission_test_dir
```

예시 출력:

```bash
-rw-r--r-- $BASE_DIRECTORY/01_permission/permission_test_file
drwxr-xr-x $BASE_DIRECTORY/01_permission/permission_test_dir
```

---

#### 7-4-3. 파일 권한을 600으로 변경

```bash
chmod 600 $BASE_DIRECTORY/01_permission/permission_test_file
stat -f "%Sp %N" $BASE_DIRECTORY/01_permission/permission_test_file
```

예시 출력:

```bash
-rw------- $BASE_DIRECTORY/01_permission/permission_test_file
```

---

#### 7-4-4. 파일 권한을 644로 변경

```bash
chmod 644 $BASE_DIRECTORY/01_permission/permission_test_file
stat -f "%Sp %N" $BASE_DIRECTORY/01_permission/permission_test_file
```

예시 출력:

```bash
-rw-r--r-- $BASE_DIRECTORY/01_permission/permission_test_file
```

---

#### 7-4-5. 디렉토리 권한을 700으로 변경

```bash
chmod 700 $BASE_DIRECTORY/01_permission/permission_test_dir
stat -f "%Sp %N" $BASE_DIRECTORY/01_permission/permission_test_dir
```

예시 출력:

```bash
drwx------ $BASE_DIRECTORY/01_permission/permission_test_dir
```

---

#### 7-4-6. 디렉토리 권한을 755로 변경

```bash
chmod 755 $BASE_DIRECTORY/01_permission/permission_test_dir
stat -f "%Sp %N" $BASE_DIRECTORY/01_permission/permission_test_dir
```

예시 출력:

```bash
drwxr-xr-x $BASE_DIRECTORY/01_permission/permission_test_dir
```

### 7-5. 권한 의미 정리

- `r`: read, 읽기 권한
- `w`: write, 쓰기 권한
- `x`: execute, 실행 권한

숫자 권한은 다음 값을 더해서 표현한다.

- `r = 4`
- `w = 2`
- `x = 1`

예시:

- `755`
  - 소유자: `7 = rwx`
  - 그룹: `5 = r-x`
  - 기타 사용자: `5 = r-x`

- `644`
  - 소유자: `6 = rw-`
  - 그룹: `4 = r--`
  - 기타 사용자: `4 = r--`

> 디렉토리에서 `x` 권한은 단순 실행이 아니라 해당 디렉토리에 진입하거나 내부 항목에 접근할 수 있음을 의미한다.

### 7-6. 검증 포인트

- 파일 권한이 `600 → 644`로 변경되는지 확인
- 디렉토리 권한이 `700 → 755`로 변경되는지 확인
- `stat -f "%Sp %N"` 결과가 단계별로 로그에 기록되는지 확인
- 파일과 디렉토리에서 `x` 권한 의미가 다름을 설명할 수 있는지 확인

---

## 8. 02_Docker: Docker 기본 점검 및 실습

### 8-1. 개요

Docker 파트는 기본 점검, 기본 운영 명령, 컨테이너 실행 실습, 커스텀 이미지 제작, 포트 매핑, 바인드 마운트, 볼륨 영속성 검증으로 나누어 진행하였다.

---

### 8-2. Docker 설치 및 기본 점검

#### 사용 스크립트

- `02_docker/00_run_docker_check.sh`

#### 실행 방법

```bash
chmod +x 02_docker/00_run_docker_check.sh
cd 02_docker
./00_run_docker_check.sh
```

실행 결과는 아래 파일에 기록된다.

```bash
02_docker/docker_check_log
```

#### 사전 조건

서울캠퍼스 환경에서는 `sudo` 사용이 제한될 수 있으므로, Docker 실행 환경으로 OrbStack을 사용하였다.  
스크립트 실행 전 OrbStack 애플리케이션이 실행 중이어야 한다.

#### 수행 명령

```bash
docker --version
docker info
```

예시 출력:

```bash
Docker version XX.XX.X, build XXXXXXX
```

```bash
Client:
 Context:    default

Server:
 Containers: ...
 Images: ...
 Server Version: ...
```

#### 설명

- `docker --version` 은 Docker CLI 설치 여부를 확인한다.
- `docker info` 는 Docker 데몬이 실제로 실행 중인지 확인한다.

---

### 8-3. Docker 기본 운영 명령

이 단계는 `00_run_docker_check.sh` 스크립트 안에서 함께 수행하였다.

#### 수행 명령

```bash
docker run hello-world
docker pull ubuntu
docker images
```

예시 출력:

```bash
REPOSITORY    TAG       IMAGE ID       CREATED       SIZE
hello-world   latest    ...            ...           ...
ubuntu        latest    ...            ...           ...
```

```bash
docker run -dit --name ubuntu-cli-test ubuntu bash
docker ps
docker ps -a
```

예시 출력:

```bash
CONTAINER ID   IMAGE    COMMAND   STATUS    NAMES
...            ubuntu   "bash"    Up ...    ubuntu-cli-test
```

```bash
docker logs hello-world-test
```

예시 출력:

```bash
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

```bash
docker run -d --name ubuntu-stats ubuntu sleep infinity
docker stats --no-stream ubuntu-stats
```

예시 출력:

```bash
CONTAINER ID   NAME          CPU %   MEM USAGE / LIMIT   MEM %
...            ubuntu-stats  ...     ...                 ...
```

실행 예시:

```bash
$ docker run -d --name ubuntu-stats ubuntu sleep infinity
b8c1c2d3e4f5g6h7i8j9k0lmnopqrstuv

$ docker stats --no-stream ubuntu-stats
CONTAINER ID   NAME          CPU %   MEM USAGE / LIMIT   MEM %
b8c1c2d3e4f5   ubuntu-stats  0.00%   1.234MiB / 7.656GiB  0.02%
```

#### 설명

- `docker images` 는 로컬 이미지 목록을 확인한다.
- `docker ps` 는 실행 중인 컨테이너만 보여준다.
- `docker ps -a` 는 종료된 컨테이너까지 포함해 전체를 보여준다.
- `docker logs` 는 종료된 컨테이너의 실행 로그도 확인할 수 있다.
- `docker stats` 는 실행 중인 컨테이너의 리소스 사용량을 보여준다.
- `docker stats` 는 실행 중인 컨테이너에 대해서만 의미 있는 정보를 보여주므로, 먼저 `sleep infinity` 를 사용해 테스트용 컨테이너를 종료되지 않은 상태로 유지했다.
- `--no-stream` 옵션은 실시간으로 계속 갱신하지 않고 자원 사용량을 1회만 출력하므로, 로그 기록이나 캡처용 확인에 적합하다.

---

### 8-4. 컨테이너 실행 실습

이 단계 역시 `00_run_docker_check.sh` 스크립트 안에서 함께 수행하였다.

#### hello-world 실행 성공 확인

```bash
docker run hello-world
```

hello-world 컨테이너는 실행 후 바로 종료되며, Docker 설치가 정상적으로 동작함을 보여주는 기본 테스트로 사용하였다.

#### ubuntu 컨테이너 실행 후 내부 명령 수행

```bash
docker run -dit --name ubuntu-cli-test ubuntu bash
docker exec ubuntu-cli-test bash -lc "ls; echo 'hello from ubuntu container'; pwd"
```

예시 출력:

```bash
bin
boot
dev
etc
home
...

hello from ubuntu container
/
```

#### attach 와 exec 차이 정리

##### attach
- 이미 실행 중인 컨테이너의 주 프로세스에 직접 붙는다.
- 컨테이너가 포그라운드 프로그램처럼 동작할 때 상태를 그대로 볼 수 있다.
- 잘못 다루면 메인 프로세스 종료와 연결될 수 있다.

##### exec
- 실행 중인 컨테이너 안에서 새 명령을 별도로 실행한다.
- 점검, 디버깅, 일회성 명령 실행에 더 안전하고 자주 사용된다.

이번 실습에서는 `docker exec`를 사용해 ubuntu 컨테이너 내부에서 `ls`, `echo`, `pwd`를 실행하였다.

---

### 8-5. Dockerfile 기반 커스텀 이미지 제작

#### 사용 스크립트

- `02_docker/01_run_custom_web.sh`

#### 실행 방법

```bash
chmod +x 02_docker/01_run_custom_web.sh
cd 02_docker
./01_run_custom_web.sh
```

실행 결과는 아래 파일에 기록된다.

```bash
02_docker/custom_web_log
```

#### 선택한 베이스 이미지

이번 단계에서는 기존 웹 서버 베이스 이미지인 `nginx:alpine`을 사용하였다.

선택 이유:
- 가볍고 빠르게 실행 가능
- 정적 HTML 파일 배포에 적합
- 포트 매핑과 웹 접속 확인이 쉬움

#### Dockerfile

파일 위치:

```bash
02_docker/web/Dockerfile
```

내용:

```dockerfile
FROM nginx:alpine

LABEL org.opencontainers.image.title="codyssey-custom-nginx"
LABEL org.opencontainers.image.description="Custom NGINX image for codyssey workstation mission"

ENV APP_ENV=dev

COPY site/ /usr/share/nginx/html/

EXPOSE 80
```

#### 빌드 명령

```bash
docker build -t codyssey-custom-web:1.0 ./web
```

예시 출력:

```bash
Successfully built ...
Successfully tagged codyssey-custom-web:1.0
```

---

### 8-6. 포트 매핑 검증

`01_run_custom_web.sh` 스크립트에서 아래 명령으로 컨테이너를 실행하였다.

```bash
docker run -d -p 8080:80 --name codyssey-web-8080 codyssey-custom-web:1.0
```

의미:
- 호스트 포트: `8080`
- 컨테이너 포트: `80`

즉, 브라우저에서 `localhost:8080` 으로 접속하면 컨테이너 내부의 NGINX 80번 포트와 연결된다.

#### 접속 확인

```bash
curl http://localhost:8080
```

브라우저 주소:

```bash
http://localhost:8080
```

예시 출력 일부:

```html
<h1>Custom NGINX Container</h1>
```

#### 설명

컨테이너는 기본적으로 호스트와 격리된 네트워크 환경에서 실행된다.  
따라서 컨테이너 내부 포트만 열려 있어서는 브라우저에서 바로 접근할 수 없다.  
`-p 호스트포트:컨테이너포트` 옵션을 사용해야 호스트에서 서비스에 접근할 수 있다.

---

### 8-7. 바인드 마운트 검증

같은 `01_run_custom_web.sh` 스크립트에서 호스트의 `site/` 디렉토리를 컨테이너 내부 NGINX 웹 루트에 연결하였다.

```bash
docker run -d -p 8081:80 \
  -v $BASE_DIRECTORY/02_docker/web/site:/usr/share/nginx/html \
  --name codyssey-web-bind \
  nginx:alpine
```

#### 접속 확인

```bash
curl http://localhost:8081
```

브라우저 주소:

```bash
http://localhost:8081
```

#### 변경 반영 확인 방법

호스트에서 `$BASE_DIRECTORY/02_docker/web/site/index.html` 내용을 수정한 뒤 같은 주소로 다시 접속하면 변경 사항이 즉시 반영된다.

기존:

```html
<h1>Custom NGINX Container</h1>
```

수정 후:

```html
<h1>Bind Mount Updated</h1>
```

이후 다시 접속:

```bash
curl http://localhost:8081
```

예시 출력 일부:

```html
<h1>Bind Mount Updated</h1>
```

#### 설명

- 호스트 파일을 바로 수정하면 컨테이너에도 즉시 반영된다.
- 개발 중 빠른 확인에 편리하다.
- 반면, 호스트 디렉토리 구조에 의존성이 생긴다.

---

### 8-8. 볼륨 영속성 검증

#### 사용 스크립트

- `02_docker/02_run_volume_test.sh`

#### 실행 방법

```bash
chmod +x 02_docker/02_run_volume_test.sh
cd 02_docker
./02_run_volume_test.sh
```

실행 결과는 아래 파일에 기록된다.

```bash
02_docker/volume_test_log
```

#### 기존 테스트 흔적 정리

```bash
docker rm -f vol-test >/dev/null 2>&1 || true
docker rm -f vol-test2 >/dev/null 2>&1 || true
docker volume rm codyssey-data >/dev/null 2>&1 || true
```

#### 볼륨 생성

```bash
docker volume create codyssey-data
```

예시 출력:

```bash
codyssey-data
```

#### 첫 번째 컨테이너에 데이터 저장

```bash
docker run -d --name vol-test -v codyssey-data:/data ubuntu sleep infinity
docker exec vol-test bash -lc "echo hi > /data/hello.txt && cat /data/hello.txt"
```

예시 출력:

```bash
hi
```

#### 컨테이너 삭제 후 새 컨테이너 연결

```bash
docker rm -f vol-test
docker run -d --name vol-test2 -v codyssey-data:/data ubuntu sleep infinity
docker exec vol-test2 bash -lc "cat /data/hello.txt"
```

예시 출력:

```bash
hi
```

#### 결과 해석

첫 번째 컨테이너를 삭제한 뒤 두 번째 컨테이너를 새로 생성했음에도 `/data/hello.txt`가 그대로 남아 있었다.  
이로써 데이터가 컨테이너 자체가 아니라 Docker 볼륨에 저장되어 영속적으로 유지됨을 확인하였다.

#### 볼륨과 바인드 마운트 차이

- 바인드 마운트
  - 호스트의 특정 폴더를 직접 연결
  - 개발 중 파일 수정 반영에 적합
- 볼륨
  - Docker가 관리하는 저장소
  - 컨테이너 삭제 후에도 데이터 유지에 적합

### 8-9. Docker 파트 검증 포인트

- Docker CLI와 데몬이 정상 동작하는지 확인
- hello-world 실행이 성공하는지 확인
- ubuntu 컨테이너 안에서 명령 실행이 가능한지 확인
- 커스텀 이미지가 정상 빌드되는지 확인
- 포트 매핑을 통해 호스트에서 웹 페이지에 접근 가능한지 확인
- 바인드 마운트 변경 사항이 즉시 반영되는지 확인
- 컨테이너 삭제 후에도 볼륨 데이터가 유지되는지 확인

### 8-10. Docker 파트 로그 파일

- `02_docker/docker_check_log`
- `02_docker/custom_web_log`
- `02_docker/volume_test_log`

---

## 9. 03_Git_GitHub: Git 설정 및 GitHub 연동

### 9-1. 사용 스크립트

- `03_github/run_git.sh`

### 9-2. 목적

Git 사용자 정보, 기본 브랜치, 현재 저장소 상태와 원격 저장소 연결 상태를 확인하는 것을 목표로 하였다.

### 9-3. 실행 방법

```bash
chmod +x 03_github/run_git.sh
./03_github/run_git.sh
```

실행 결과는 아래 파일에 기록된다.

```bash
03_github/github_log
```

### 9-4. 수행 내용

- Git 사용자 이름 확인
- Git 사용자 이메일 확인
- 기본 브랜치 설정 확인
- 전체 Git 설정 확인
- 원격 저장소 연결 상태 확인

### 9-5. 확인 명령

```bash
git config --global user.name
git config --global user.email
git config --global init.defaultBranch
git config --list
git remote -v
```

### 9-6. 검증 포인트

- Git 사용자 이름과 이메일이 설정되어 있는지 확인
- 기본 브랜치 설정이 적용되어 있는지 확인
- 현재 저장소가 원격 저장소와 연결되어 있는지 확인
- VS Code Source Control 패널에서 저장소가 정상적으로 인식되는지 확인

![캡처](./img/vscode.png)

---

## 10. 04_Bonus_Docker_Compose

### 10-1. 목적

Docker Compose를 이용해 `nginx`, `wordpress`, `mariadb` 3개 서비스를 한 번에 구성하고, 서비스 간 연결과 데이터베이스 연동 상태를 점검하는 것을 목표로 하였다.

### 10-2. 구성 파일

- `04_bonus_compose/compose.yaml`
- `04_bonus_compose/nginx/default.conf`
- `04_bonus_compose/run_bonus_compose.sh`
- `04_bonus_compose/.env`

### 10-3. .env 예시

```env
WEB_PORT=80

WORDPRESS_DB_NAME=wordpress
WORDPRESS_DB_USER=wpuser
WORDPRESS_DB_PASSWORD=wppass

MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=wppass
MYSQL_ROOT_PASSWORD=rootpass
```

주의:
- `WORDPRESS_DB_NAME` 과 `MYSQL_DATABASE` 는 같은 값이어야 한다.
- `WORDPRESS_DB_USER` 과 `MYSQL_USER` 는 같은 값이어야 한다.
- `WORDPRESS_DB_PASSWORD` 과 `MYSQL_PASSWORD` 는 같은 값이어야 한다.

### 10-4. Docker Compose를 사용한 이유

기존에는 여러 컨테이너를 각각 `docker run` 명령으로 실행해야 했지만, Compose를 사용하면 실행 설정을 `compose.yaml` 파일에 한 번 정리해두고 동일한 환경을 반복해서 쉽게 재현할 수 있다.

즉, Docker Compose는 컨테이너 실행 명령을 단순한 일회성 입력이 아니라 **문서화된 실행 설정**으로 관리할 수 있게 해준다.

### 10-5. 서비스 구성

이번 실습에서는 다음 3개의 서비스를 구성하였다.

- `nginx` : 외부 요청을 받는 프록시 서버
- `wordpress` : 웹 애플리케이션 서버
- `mariadb` : WordPress가 사용하는 데이터베이스 서버

구조는 다음과 같다.

브라우저 → `localhost:80` → `nginx` → `wordpress` → `mariadb`

### 10-6. 프록시 패스(proxy_pass)

nginx는 직접 페이지를 생성하지 않고, 내부 네트워크의 WordPress 컨테이너로 요청을 넘기도록 설정하였다.

예를 들어 `/` 경로로 들어온 요청은 내부적으로 `wordpress:80` 으로 전달된다.  
이때 사용한 것이 `proxy_pass` 설정이다.

### 10-7. 내부 네트워크와 서비스 이름 기반 통신

Docker Compose를 실행하면 프로젝트 전용 네트워크가 자동으로 생성된다.  
같은 Compose에 속한 서비스들은 이 네트워크에 함께 연결되며, 서비스 이름은 내부 DNS처럼 동작한다.

예를 들어:
- `wordpress` : WordPress 컨테이너 주소처럼 사용
- `mariadb` : MariaDB 컨테이너 주소처럼 사용

이 구조를 통해 Docker Compose의 **서비스 디스커버리** 개념을 확인할 수 있었다.

### 10-8. WordPress와 MariaDB 연동

WordPress는 실행 시 데이터베이스 접속 정보를 환경 변수로 전달받도록 구성하였다.  
예를 들어 데이터베이스 호스트는 `mariadb:3306`, 데이터베이스 이름은 `wordpress` 와 같이 설정하였다.

MariaDB 컨테이너는 시작되면서 WordPress가 사용할 데이터베이스와 계정을 생성하고, WordPress는 그 계정으로 접속해 필요한 테이블을 자동으로 구성하였다.

설치 완료 후에는 MariaDB 내부를 조회하여 다음 내용을 확인하였다.

- `wp_options` 테이블에 `siteurl`, `home` 값이 저장되었는지
- `wp_users` 테이블에 관리자 계정이 생성되었는지

### 10-9. Compose 운영 명령어

```bash
docker compose up -d
docker compose down
docker compose ps
docker compose logs
docker compose logs nginx
docker compose logs wordpress
docker compose logs mariadb
```

### 10-10. 검증 포인트

- Compose로 여러 컨테이너를 동시에 실행할 수 있는지 확인
- nginx가 wordpress로 프록시되는지 확인
- WordPress와 MariaDB가 같은 설정으로 연결되는지 확인
- 설치 완료 후 `wp_options`, `wp_users` 등 주요 테이블을 조회할 수 있는지 확인

### 10-11. 로그 파일

- `04_bonus_compose/bonus_demo_log`

---

## 11. 05_Bonus_GitHub_SSH

### 11-1. 사용 스크립트

- `05_bonus_github/run_bonus_git.sh`

### 11-2. 목적

GitHub SSH 키를 생성하거나 기존 키를 재사용하고, 공개키 등록 및 원격 저장소 SSH 전환 절차를 점검하는 것을 목표로 하였다.

### 11-3. 수행 내용

- 현재 Git 저장소와 원격 저장소 상태 확인
- `~/.ssh` 디렉토리 준비
- 기존 SSH 키 존재 여부 확인
- 필요 시 `ed25519` 키 생성
- `ssh-agent` 실행 및 `ssh-add` 등록
- 공개키 출력 및 별도 파일 저장
- GitHub SSH 접속 테스트
- 필요 시 `origin` 원격 저장소를 HTTPS에서 SSH로 변경

### 11-4. 확인 명령 예시

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
ssh -T git@github.com
git remote -v
```

### 11-5. 검증 포인트

- SSH 키가 정상적으로 생성 또는 재사용되는지 확인
- 공개키를 GitHub에 등록할 수 있는 형태로 출력할 수 있는지 확인
- `ssh -T git@github.com` 결과로 SSH 인증 상태를 확인할 수 있는지 점검
- 현재 저장소의 `origin` URL이 SSH 방식으로 전환 가능한지 확인

### 11-6. 주의사항

이 스크립트는 점검뿐 아니라 SSH 키 생성, 에이전트 등록, 원격 저장소 URL 변경까지 수행할 수 있으므로 실행 전 현재 저장소 상태를 먼저 확인해야 한다.

### 11-7. 로그 파일

- `05_bonus_github/github_ssh_log`

---

## 12. 트러블슈팅

### 12-1. `pwd` 결과가 실행 위치에 따라 달라지는 문제

- 문제: 스크립트를 실행하는 위치에 따라 `pwd` 결과가 달라져, README에 기록한 예상 경로와 실제 출력이 일치하지 않는 문제가 있었다.
- 원인: 스크립트 시작 위치가 고정되지 않아서, 현재 셸의 작업 디렉토리에 따라 결과가 달라졌다고 판단하였다.
- 해결: `BASE="$(cd "$(dirname "$0")" && pwd -P)"` 로 스크립트 위치를 기준 경로로 잡고, `cd "$BASE"` 를 추가하여 작업 디렉토리를 고정하였다.

---

### 12-2. Docker가 자꾸 꺼지는 문제 (`attach` 사용 시)

- 문제: ubuntu 컨테이너에 접근하는 과정에서 컨테이너가 자꾸 종료되거나, 터미널에서 빠져나온 뒤 컨테이너가 꺼진 것처럼 보이는 문제가 있었다.
- 원인: `docker attach` 는 실행 중인 컨테이너의 주 프로세스에 직접 연결되기 때문에, 종료 입력이나 세션 종료가 곧 메인 프로세스 종료와 연결될 수 있었다.
- 해결: 내부 확인 방식은 `attach` 대신 `docker exec` 중심으로 변경하였다.

---

### 12-3. Docker 데몬 연결 실패 문제

- 문제: `docker --version` 은 동작하지만 `docker info` 가 실패하는 경우가 있었다.
- 원인: Docker CLI 는 설치되어 있었지만, Docker 엔진이 실행 중이 아니었을 가능성이 있었다.
- 해결: OrbStack을 먼저 실행한 뒤 다시 `docker info` 를 실행하도록 절차를 정리하였다.

---

### 12-4. 도커 심볼릭 링크 인식하지 못하는 문제점

- 현재 캐빈 환경에서 `pwd` 결과는 `/home/사용자/...` 혹은  `/Users/사용자/...` 형태로 보인다.
  `-P` 옵션을 이용해 Canonical주소를 확인해보면 `/Users/사용자/...` 형태로 보여 경로가 서로 다른 것처럼 보이는 문제가 있었다.
- 원인: `/home` 이 실제 디렉토리가 아니라 `/Users` 를 가리키는 심볼릭 링크로 연결되어 있었기 때문이다. 따라서 일반 `pwd` 는 현재 셸이 인식하는 경로를 보여주고, `pwd -P` 는 심볼릭 링크를 따라가 실제 물리 경로(canonical path)를 보여준다.
- 확인: 쉘의 진입 점에 따라서 home인지 Users인지 다르게 출력되는 것을 확인했다.

```bash
pwd
pwd -P
ls -ld /home
ls -ld /Users
```


---

### 12-5. 포트 충돌로 포트 매핑이 실패하는 문제

- 문제: `-p 8080:80` 실행 시 호스트 포트가 이미 사용 중이면 컨테이너가 시작되지 않을 수 있다.
- 진단:
  1. 에러 메시지에서 `address already in use`, `port is already allocated` 문구 확인
  2. `docker ps` 로 같은 포트를 사용 중인 컨테이너 확인
  3. `lsof -i :8080` 로 호스트 프로세스 확인
- 해결:
  - 기존 컨테이너 종료 또는 삭제
  - 점유 중인 호스트 프로세스 종료
  - 다른 호스트 포트로 변경

---

## 13. 배운 점

### 13-1. 절대 경로와 상대 경로

- 절대 경로는 루트(`/`)부터 시작하는 전체 경로이다.
- 상대 경로는 현재 위치를 기준으로 해석되는 경로이다.

예시:
- 절대 경로: `$BASE_DIRECTORY`
- 상대 경로: `./entry.sh`

### 13-2. 파일 권한

- 파일과 디렉토리는 각각 읽기, 쓰기, 실행 권한을 가진다.
- 숫자 권한 표기(예: 755, 644)는 권한 조합을 숫자로 나타낸 것이다.
- 같은 숫자 권한이라도 파일과 디렉토리에서 의미가 다를 수 있다.

### 13-3. 포트 매핑

- 컨테이너 내부 서비스는 기본적으로 외부에서 바로 접근할 수 없다.
- 호스트 포트와 컨테이너 포트를 연결해야 브라우저나 `curl`로 접근할 수 있다.

### 13-4. 볼륨 영속성

- 컨테이너는 삭제될 수 있지만, 볼륨은 별도로 유지할 수 있다.
- 따라서 중요한 데이터는 컨테이너 내부가 아니라 볼륨에 저장하는 것이 적절하다.

### 13-5. Git과 GitHub, HTTPS와 SSH

- Git은 로컬 버전 관리 도구이고, GitHub는 원격 저장소 서비스이다.
- 원격 저장소는 HTTPS 방식과 SSH 방식으로 연결할 수 있으며, SSH는 키 기반 인증을 사용한다.

---

## 14. 제출 자료 정리

최종 제출 시 아래 자료를 함께 정리한다.

- GitHub 저장소 링크
- `README.md`
- 각 단계별 실행 로그 파일
- Docker 웹 페이지 접속 화면 캡처
- VS Code 또는 GitHub 원격 저장소 연결 화면 캡처
- Docker Compose 서비스 실행 화면 및 응답 확인 캡처
- 민감 정보 마스킹 확인

---

## 15. 참고

- README에는 명령어와 예시 출력뿐 아니라 실제 실행 로그 파일 위치도 함께 기록하였다.
- 최종 제출 시에는 브라우저 접속 화면, VS Code 연동 화면, GitHub 저장소 화면 등 시각적 증거를 함께 첨부한다.
- 민감한 정보(토큰, 비밀번호, 개인키)는 로그나 스크린샷에 포함되지 않도록 반드시 마스킹한다.
