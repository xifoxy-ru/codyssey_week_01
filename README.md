# 개발 워크스테이션 구축 미션

> 이 문서는 `~/__dev/codyssey_week_01` 디렉토리에서 작업한 내용을 기준으로 작성되었습니다.  
> 현재는 **1단계 터미널 기본 조작**, **2단계 파일 권한 실습**까지 반영되어 있으며, 이후 Docker/Git 항목을 계속 이어서 추가할 예정입니다.

---

## 1. 프로젝트 개요

이 과제의 목표는 터미널, Docker, Git/GitHub를 활용하여 재현 가능한 개발 워크스테이션 환경을 직접 구축하고, 그 과정과 결과를 기술 문서로 정리하는 것입니다.

현재까지 진행한 범위는 다음과 같습니다.
- 터미널 기본 조작 자동화 스크립트 작성
- 실행 결과 로그 파일 기록
- 파일 및 디렉토리 권한 실습 자동화
- README 구조를 제출용 형식으로 확장

---

## 2. 실행 환경

아래 정보는 실제 실행 후 결과에 맞게 업데이트합니다.
- OS: macOS
- Shell: bash
- Terminal: iTerm2 또는 macOS Terminal
- Docker: 추후 작성 예정
- Git: 추후 작성 예정

버전 확인 명령 예시:

```bash
uname -a
echo $SHELL
docker --version
git --version
```

---

## 3. 수행 체크리스트

- [x] 터미널 기본 조작 및 폴더 구성
- [x] 파일 권한 실습
- [ ] Docker 설치 및 기본 점검
- [ ] hello-world 실행
- [ ] ubuntu 컨테이너 실행 및 내부 명령 확인
- [ ] Docker 기본 운영 명령 확인
- [ ] Dockerfile 기반 커스텀 이미지 제작
- [ ] 포트 매핑 검증
- [ ] 바인드 마운트 검증
- [ ] 볼륨 영속성 검증
- [ ] Git 설정
- [ ] GitHub / VSCode 연동
- [ ] 트러블슈팅 2건 이상 정리

---

## 4. 1단계: 터미널 기본 조작

### 4-1. 사용 스크립트

터미널 기본 조작은 `run_step.sh` 스크립트로 자동화했다.

실행 방법:

```bash
chmod +x run_step.sh
./run_step.sh
```

실행 결과는 아래 파일에 기록된다.

```bash
~/__dev/codyssey_week_01/terminal_cli
```

---

### 4-2. 스크립트 동작 개요

이 스크립트는 다음 순서로 실행된다.

1. 현재 위치 확인
2. 작업 디렉토리 생성
3. 전체 파일 목록 확인
4. 빈 파일 생성
5. 파일 복사
6. 파일 이름 변경
7. 파일 삭제 후 목록 확인
8. 로그 파일 내용 확인

각 단계는 엔터 입력 후 실행되며, 화면 출력과 동시에 로그 파일에도 결과를 남긴다.

---

### 4-3. 수행 명령 및 확인 항목

#### 4-3-1. 현재 위치 확인

```bash
pwd
```

예상 출력:

```bash
/Users/xifoxy.ru1115/__dev/codyssey_week_01
```

> `run_step.sh` 내부에서 `cd "$BASE"`를 수행하므로, `pwd` 결과가 작업 디렉토리 기준으로 맞춰지도록 구성했다.

---

#### 4-3-2. 작업 디렉토리 생성

```bash
mkdir -p ~/__dev/codyssey_week_01/answer_directory
ls -la ~/__dev/codyssey_week_01 | grep answer_directory
```

예상 출력:

```bash
drwxr-xr-x  ... answer_directory
```

---

#### 4-3-3. 전체 파일 목록 확인

```bash
ls -la ~/__dev/codyssey_week_01
```

예상 출력:

```bash
.
..
answer_directory
terminal_cli
```

---

#### 4-3-4. 빈 파일 생성

```bash
touch ~/__dev/codyssey_week_01/test
ls -la ~/__dev/codyssey_week_01/test
```

예상 출력:

```bash
-rw-r--r--  ... /Users/xifoxy.ru1115/__dev/codyssey_week_01/test
```

---

#### 4-3-5. 파일 복사

```bash
cp ~/__dev/codyssey_week_01/test ~/__dev/codyssey_week_01/test_copy
ls -la ~/__dev/codyssey_week_01 | grep test
```

예상 출력:

```bash
-rw-r--r--  ... test
-rw-r--r--  ... test_copy
```

---

#### 4-3-6. 파일 이름 변경

```bash
mv ~/__dev/codyssey_week_01/test_copy ~/__dev/codyssey_week_01/test_renamed
ls -la ~/__dev/codyssey_week_01 | grep test
```

예상 출력:

```bash
-rw-r--r--  ... test
-rw-r--r--  ... test_renamed
```

---

#### 4-3-7. 파일 삭제 후 목록 확인

```bash
rm ~/__dev/codyssey_week_01/test_renamed ~/__dev/codyssey_week_01/test
ls -la ~/__dev/codyssey_week_01
```

예상 출력:

```bash
.
..
answer_directory
terminal_cli
```

---

#### 4-3-8. 로그 파일 내용 확인

```bash
cat ~/__dev/codyssey_week_01/terminal_cli
```

예상 출력:

```bash
=== pwd 현재 위치 ===
/Users/xifoxy.ru1115/__dev/codyssey_week_01

=== mkdir 파일생성 ===
drwxr-xr-x ... answer_directory
```

> 실제 로그에는 각 단계의 결과가 누적된다.

---

### 4-4. 로그 파일 생성 방식

스크립트는 기존 `terminal_cli` 파일을 삭제한 뒤, 각 단계마다 `>> "$LOG"` 방식으로 다시 기록한다.  
즉, 실행할 때마다 이전 로그를 초기화하고 새 로그를 누적 생성하는 구조이다.

---

## 5. 2단계: 파일 권한 실습

### 5-1. 사용 스크립트

파일 및 디렉토리 권한 실습은 `run_permission.sh` 스크립트로 진행했다.

실행 방법:

```bash
chmod +x run_permission.sh
./run_permission.sh
```

실행 결과는 아래 파일에 기록된다.

```bash
~/__dev/codyssey_week_01/permission_log
```

---

### 5-2. 권한 실습 목적

과제 요구사항에 따라 아래 두 대상을 사용했다.

- 파일 1개: `permission_test_file`
- 디렉토리 1개: `permission_test_dir`

변경 전/후 권한을 비교하여 파일 권한과 디렉토리 권한의 차이를 확인했다.

---

### 5-3. 수행 명령

#### 5-3-1. 실습용 파일/디렉토리 생성

```bash
touch ~/__dev/codyssey_week_01/permission_test_file
mkdir -p ~/__dev/codyssey_week_01/permission_test_dir
ls -ld ~/__dev/codyssey_week_01/permission_test_file ~/__dev/codyssey_week_01/permission_test_dir
```

예시 출력:

```bash
-rw-r--r--  ... /Users/xifoxy.ru1115/__dev/codyssey_week_01/permission_test_file
drwxr-xr-x  ... /Users/xifoxy.ru1115/__dev/codyssey_week_01/permission_test_dir
```

---

#### 5-3-2. 초기 권한 확인

```bash
stat -f "%Sp %N" ~/__dev/codyssey_week_01/permission_test_file ~/__dev/codyssey_week_01/permission_test_dir
```

예시 출력:

```bash
-rw-r--r-- /Users/xifoxy.ru1115/__dev/codyssey_week_01/permission_test_file
drwxr-xr-x /Users/xifoxy.ru1115/__dev/codyssey_week_01/permission_test_dir
```

---

#### 5-3-3. 파일 권한을 600으로 변경

```bash
chmod 600 ~/__dev/codyssey_week_01/permission_test_file
stat -f "%Sp %N" ~/__dev/codyssey_week_01/permission_test_file
```

예시 출력:

```bash
-rw------- /Users/xifoxy.ru1115/__dev/codyssey_week_01/permission_test_file
```

---

#### 5-3-4. 파일 권한을 644로 변경

```bash
chmod 644 ~/__dev/codyssey_week_01/permission_test_file
stat -f "%Sp %N" ~/__dev/codyssey_week_01/permission_test_file
```

예시 출력:

```bash
-rw-r--r-- /Users/xifoxy.ru1115/__dev/codyssey_week_01/permission_test_file
```

---

#### 5-3-5. 디렉토리 권한을 700으로 변경

```bash
chmod 700 ~/__dev/codyssey_week_01/permission_test_dir
stat -f "%Sp %N" ~/__dev/codyssey_week_01/permission_test_dir
```

예시 출력:

```bash
drwx------ /Users/xifoxy.ru1115/__dev/codyssey_week_01/permission_test_dir
```

---

#### 5-3-6. 디렉토리 권한을 755로 변경

```bash
chmod 755 ~/__dev/codyssey_week_01/permission_test_dir
stat -f "%Sp %N" ~/__dev/codyssey_week_01/permission_test_dir
```

예시 출력:

```bash
drwxr-xr-x /Users/xifoxy.ru1115/__dev/codyssey_week_01/permission_test_dir
```

---

### 5-4. 권한 의미 정리

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

---

## 6. 3단계: Docker 설치 및 기본 점검

추후 작성 예정.

예정 항목:

- `docker --version`
- `docker info`
- `docker run hello-world`

---

## 7. 4단계: Docker 기본 운영 명령

추후 작성 예정.

예정 항목:

- `docker images`
- `docker ps`
- `docker ps -a`
- `docker logs`
- `docker stats --no-stream`

---

## 8. 5단계: 컨테이너 실행 실습

추후 작성 예정.

예정 항목:

- `docker pull ubuntu`
- `docker run -it ubuntu bash`
- 내부 명령: `ls`, `echo`, `pwd`
- `attach`, `exec` 차이 정리

---

## 9. 6단계: Dockerfile 기반 커스텀 이미지 제작

추후 작성 예정.

예정 항목:

- 베이스 이미지 선택
- Dockerfile 작성
- 이미지 빌드
- 컨테이너 실행

---

## 10. 7단계: 포트 매핑 검증

추후 작성 예정.

예정 항목:

- `docker run -d -p <host_port>:<container_port> ...`
- 브라우저 접속 화면 또는 `curl` 응답 첨부

---

## 11. 8단계: 바인드 마운트 검증

추후 작성 예정.

---

## 12. 9단계: 볼륨 영속성 검증

추후 작성 예정.

---

## 13. 10단계: Git 설정 및 GitHub / VSCode 연동

추후 작성 예정.

예정 항목:

- `git config --list`
- 사용자 정보 설정
- 기본 브랜치 설정
- GitHub 로그인 및 저장소 연동

---

## 14. 트러블슈팅

현재까지 기록 예정 항목:

1. `pwd` 결과가 실행 위치에 따라 달라지는 문제  
   - 원인: 스크립트 실행 위치가 고정되지 않음
   - 해결: `cd "$BASE"` 추가

2. 화면 출력과 로그 출력의 일관성이 어긋나는 문제  
   - 원인: 일부 단계에서 로그는 `grep`, 화면은 전체 `ls` 사용
   - 해결: 동일 명령으로 통일

---

## 15. 배운 점

### 절대 경로와 상대 경로
- 절대 경로는 루트(`/`)부터 시작하는 전체 경로이다.
- 상대 경로는 현재 위치를 기준으로 해석되는 경로이다.

예시:
- 절대 경로: `/Users/xifoxy.ru1115/__dev/codyssey_week_01`
- 상대 경로: `./run_step.sh`

### 파일 권한
- 파일과 디렉토리는 각각 읽기, 쓰기, 실행 권한을 가진다.
- 숫자 권한 표기(예: 755, 644)는 권한 조합을 숫자로 나타낸 것이다.

---

## 16. 참고

- 모든 로그와 스크린샷에는 민감한 정보가 포함되지 않도록 주의한다.
- README는 이후 Docker, Git, GitHub 연동 내용을 계속 이어서 추가할 예정이다.