# 개발 워크스테이션 구축 미션

## 1단계: 터미널 기본 조작

### 1-1. 현재 위치 확인
```bash
pwd
```

**예상 출력:**
```
/Users/xifoxy.ru1115
```

**결과 저장:**
```bash
pwd >> ~/dev-workstation/ans/01_terminal.txt
```

---

### 1-2. 작업 디렉토리 생성
```bash
mkdir -p ~/dev-workstation/ans
mkdir -p ~/dev-workstation/app
mkdir -p ~/dev-workstation/site
```

**결과 저장:**
```bash
echo "=== mkdir 완료 ===" >> ~/dev-workstation/ans/01_terminal.txt
ls -la ~/ | grep dev-workstation >> ~/dev-workstation/ans/01_terminal.txt
```

---

### 1-3. 숨김 파일 포함 목록 확인
```bash
ls -la ~/dev-workstation
```

**결과 저장:**
```bash
echo "=== ls -la ===" >> ~/dev-workstation/ans/01_terminal.txt
ls -la ~/dev-workstation >> ~/dev-workstation/ans/01_terminal.txt
```

---

### 1-4. 빈 파일 생성
```bash
touch ~/dev-workstation/test.txt
```

**결과 저장:**
```bash
echo "=== touch 결과 ===" >> ~/dev-workstation/ans/01_terminal.txt
ls -la ~/dev-workstation/test.txt >> ~/dev-workstation/ans/01_terminal.txt
```

---

### 1-5. 파일 복사
```bash
cp ~/dev-workstation/test.txt ~/dev-workstation/test_copy.txt
```

**결과 저장:**
```bash
echo "=== cp 결과 ===" >> ~/dev-workstation/ans/01_terminal.txt
ls -la ~/dev-workstation/ >> ~/dev-workstation/ans/01_terminal.txt
```

---

### 1-6. 파일 이름 변경
```bash
mv ~/dev-workstation/test_copy.txt ~/dev-workstation/test_renamed.txt
```

**결과 저장:**
```bash
echo "=== mv 결과 ===" >> ~/dev-workstation/ans/01_terminal.txt
ls -la ~/dev-workstation/ >> ~/dev-workstation/ans/01_terminal.txt
```

---

### 1-7. 파일 내용 확인
```bash
echo "hello workstation" > ~/dev-workstation/test.txt
cat ~/dev-workstation/test.txt
```

**결과 저장:**
```bash
echo "=== cat 결과 ===" >> ~/dev-workstation/ans/01_terminal.txt
cat ~/dev-workstation/test.txt >> ~/dev-workstation/ans/01_terminal.txt
```

---

### 1-8. 파일 삭제
```bash
rm ~/dev-workstation/test_renamed.txt
```

**결과 저장:**
```bash
echo "=== rm 후 목록 ===" >> ~/dev-workstation/ans/01_terminal.txt
ls -la ~/dev-workstation/ >> ~/dev-workstation/ans/01_terminal.txt
```

---

## 2단계: 권한 실습

### 2-1. 현재 권한 확인
```bash
ls -l ~/dev-workstation/test.txt
ls -ld ~/dev-workstation/app
```

**결과 저장:**
```bash
echo "=== 권한 변경 전 ===" >> ~/dev-workstation/ans/02_permission.txt
ls -l ~/dev-workstation/test.txt >> ~/dev-workstation/ans/02_permission.txt
ls -ld ~/dev-workstation/app >> ~/dev-workstation/ans/02_permission.txt
```

---

### 2-2. 파일 권한 변경 (644 → 755)
```bash
chmod 755 ~/dev-workstation/test.txt
```

**결과 저장:**
```bash
echo "=== 파일 권한 변경 후 (755) ===" >> ~/dev-workstation/ans/02_permission.txt
ls -l ~/dev-workstation/test.txt >> ~/dev-workstation/ans/02_permission.txt
```

---

### 2-3. 디렉토리 권한 변경 (755 → 700)
```bash
chmod 700 ~/dev-workstation/app
```

**결과 저장:**
```bash
echo "=== 디렉토리 권한 변경 후 (700) ===" >> ~/dev-workstation/ans/02_permission.txt
ls -ld ~/dev-workstation/app >> ~/dev-workstation/ans/02_permission.txt
```

---

### 2-4. 원래대로 복구
```bash
chmod 755 ~/dev-workstation/app
```

**결과 저장:**
```bash
echo "=== 디렉토리 권한 복구 (755) ===" >> ~/dev-workstation/ans/02_permission.txt
ls -ld ~/dev-workstation/app >> ~/dev-workstation/ans/02_permission.txt
```

---

## 3단계: Docker 점검

### 3-1. OrbStack 실행 확인
> OrbStack 앱이 실행 중인지 먼저 확인하세요 (메뉴바 아이콘)

```bash
docker --version
```

**결과 저장:**
```bash
echo "=== Docker 버전 ===" >> ~/dev-workstation/ans/03_docker_check.txt
docker --version >> ~/dev-workstation/ans/03_docker_check.txt
```

---

### 3-2. Docker 데몬 상태 확인
```bash
docker info
```

**결과 저장:**
```bash
echo "=== Docker info ===" >> ~/dev-workstation/ans/03_docker_check.txt
docker info >> ~/dev-workstation/ans/03_docker_check.txt
```

---

### 3-3. 이미지 목록 확인
```bash
docker images
```

**결과 저장:**
```bash
echo "=== Docker images ===" >> ~/dev-workstation/ans/03_docker_check.txt
docker images >> ~/dev-workstation/ans/03_docker_check.txt
```

---

### 3-4. 컨테이너 목록 확인
```bash
docker ps -a
```

**결과 저장:**
```bash
echo "=== Docker ps -a ===" >> ~/dev-workstation/ans/03_docker_check.txt
docker ps -a >> ~/dev-workstation/ans/03_docker_check.txt
```

---

## 4단계: 컨테이너 실행 실습

### 4-1. hello-world 실행
```bash
docker run hello-world
```

**결과 저장:**
```bash
echo "=== hello-world 실행 ===" >> ~/dev-workstation/ans/04_container.txt
docker run hello-world >> ~/dev-workstation/ans/04_container.txt 2>&1
```

---

### 4-2. ubuntu 컨테이너 실행 및 내부 명령
```bash
docker run --rm ubuntu bash -c "ls / && echo 'ubuntu container works!'"
```

**결과 저장:**
```bash
echo "=== ubuntu 컨테이너 내부 명령 ===" >> ~/dev-workstation/ans/04_container.txt
docker run --rm ubuntu bash -c "ls / && echo 'ubuntu container works!'" >> ~/dev-workstation/ans/04_container.txt 2>&1
```

---

### 4-3. 실행 후 컨테이너 목록 확인
```bash
docker ps -a
```

**결과 저장:**
```bash
echo "=== 실행 후 컨테이너 목록 ===" >> ~/dev-workstation/ans/04_container.txt
docker ps -a >> ~/dev-workstation/ans/04_container.txt
```

---

## 5단계: Dockerfile 커스텀 이미지

### 5-1. HTML 파일 생성
```bash
cat > ~/dev-workstation/site/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>My Workstation</title></head>
<body>
  <h1>Hello, Dev Workstation!</h1>
  <p>Custom nginx container is running.</p>
</body>
</html>
EOF
```

**결과 저장:**
```bash
echo "=== index.html 내용 ===" >> ~/dev-workstation/ans/05_dockerfile.txt
cat ~/dev-workstation/site/index.html >> ~/dev-workstation/ans/05_dockerfile.txt
```

---

### 5-2. Dockerfile 생성
```bash
cat > ~/dev-workstation/Dockerfile << 'EOF'
FROM nginx:alpine
LABEL org.opencontainers.image.title="my-custom-nginx"
ENV APP_ENV=dev
COPY site/ /usr/share/nginx/html/
EOF
```

**결과 저장:**
```bash
echo "=== Dockerfile 내용 ===" >> ~/dev-workstation/ans/05_dockerfile.txt
cat ~/dev-workstation/Dockerfile >> ~/dev-workstation/ans/05_dockerfile.txt
```

---

### 5-3. 이미지 빌드
```bash
cd ~/dev-workstation
docker build -t my-web:1.0 .
```

**결과 저장:**
```bash
echo "=== 빌드 결과 ===" >> ~/dev-workstation/ans/05_dockerfile.txt
docker build -t my-web:1.0 . >> ~/dev-workstation/ans/05_dockerfile.txt 2>&1
echo "=== 빌드 후 이미지 목록 ===" >> ~/dev-workstation/ans/05_dockerfile.txt
docker images >> ~/dev-workstation/ans/05_dockerfile.txt
```

---

## 6단계: 포트 매핑 (2회)

### 6-1. 첫 번째 실행 (8080 포트)
```bash
docker run -d -p 8080:80 --name my-web-8080 my-web:1.0
```

**결과 저장:**
```bash
echo "=== 8080 포트 실행 ===" >> ~/dev-workstation/ans/06_port.txt
docker run -d -p 8080:80 --name my-web-8080 my-web:1.0 >> ~/dev-workstation/ans/06_port.txt 2>&1
echo "=== curl 8080 응답 ===" >> ~/dev-workstation/ans/06_port.txt
sleep 1 && curl http://localhost:8080 >> ~/dev-workstation/ans/06_port.txt 2>&1
```

> 브라우저에서 `http://localhost:8080` 접속 후 **주소창 포함 스크린샷** 저장

---

### 6-2. 두 번째 실행 (8081 포트)
```bash
docker run -d -p 8081:80 --name my-web-8081 my-web:1.0
```

**결과 저장:**
```bash
echo "=== 8081 포트 실행 ===" >> ~/dev-workstation/ans/06_port.txt
docker run -d -p 8081:80 --name my-web-8081 my-web:1.0 >> ~/dev-workstation/ans/06_port.txt 2>&1
echo "=== curl 8081 응답 ===" >> ~/dev-workstation/ans/06_port.txt
sleep 1 && curl http://localhost:8081 >> ~/dev-workstation/ans/06_port.txt 2>&1
```

> 브라우저에서 `http://localhost:8081` 접속 후 **주소창 포함 스크린샷** 저장

---

### 6-3. 실행 중인 컨테이너 확인
```bash
docker ps
```

**결과 저장:**
```bash
echo "=== 실행 중 컨테이너 ===" >> ~/dev-workstation/ans/06_port.txt
docker ps >> ~/dev-workstation/ans/06_port.txt
```

---

### 6-4. 로그 확인
```bash
docker logs my-web-8080
```

**결과 저장:**
```bash
echo "=== my-web-8080 로그 ===" >> ~/dev-workstation/ans/06_port.txt
docker logs my-web-8080 >> ~/dev-workstation/ans/06_port.txt 2>&1
```

---

## 7단계: 볼륨 영속성 검증

### 7-1. 볼륨 생성
```bash
docker volume create mydata
```

**결과 저장:**
```bash
echo "=== 볼륨 생성 ===" >> ~/dev-workstation/ans/07_volume.txt
docker volume create mydata >> ~/dev-workstation/ans/07_volume.txt
docker volume ls >> ~/dev-workstation/ans/07_volume.txt
```

---

### 7-2. 컨테이너 연결 + 데이터 쓰기
```bash
docker run -d --name vol-test -v mydata:/data ubuntu sleep infinity
docker exec vol-test bash -c "echo 'hello volume' > /data/hello.txt && cat /data/hello.txt"
```

**결과 저장:**
```bash
echo "=== 데이터 쓰기 ===" >> ~/dev-workstation/ans/07_volume.txt
docker run -d --name vol-test -v mydata:/data ubuntu sleep infinity >> ~/dev-workstation/ans/07_volume.txt 2>&1
sleep 1
docker exec vol-test bash -c "echo 'hello volume' > /data/hello.txt && cat /data/hello.txt" >> ~/dev-workstation/ans/07_volume.txt 2>&1
```

---

### 7-3. 컨테이너 삭제
```bash
docker rm -f vol-test
```

**결과 저장:**
```bash
echo "=== 컨테이너 삭제 ===" >> ~/dev-workstation/ans/07_volume.txt
docker rm -f vol-test >> ~/dev-workstation/ans/07_volume.txt
docker ps -a >> ~/dev-workstation/ans/07_volume.txt
```

---

### 7-4. 새 컨테이너로 데이터 유지 확인
```bash
docker run -d --name vol-test2 -v mydata:/data ubuntu sleep infinity
docker exec vol-test2 bash -c "cat /data/hello.txt"
```

**결과 저장:**
```bash
echo "=== 새 컨테이너에서 데이터 확인 ===" >> ~/dev-workstation/ans/07_volume.txt
docker run -d --name vol-test2 -v mydata:/data ubuntu sleep infinity >> ~/dev-workstation/ans/07_volume.txt 2>&1
sleep 1
docker exec vol-test2 bash -c "cat /data/hello.txt" >> ~/dev-workstation/ans/07_volume.txt 2>&1
```

---

## 8단계: Git 설정 
