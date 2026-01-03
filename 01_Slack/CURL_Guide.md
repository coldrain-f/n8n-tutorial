# curl 명령어 가이드

API 테스트에 자주 사용하는 curl 명령어 문법 정리입니다.

## 기본 구조

```bash
curl [옵션] [URL]
```

---

## `\` (역슬래시) - 줄 이어쓰기

명령어가 길어질 때 **여러 줄로 나눠서 작성**할 수 있게 해줍니다.

### 한 줄로 쓰면
```bash
curl -X POST -H "Content-Type: application/json" -d '{"msg":"hi"}' http://example.com
```

### `\`로 나누면 (동일한 명령어)
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"msg":"hi"}' \
  http://example.com
```

> ⚠️ **주의**: `\` 뒤에 공백이 있으면 안 됩니다! 바로 엔터를 눌러야 해요.

## 자주 쓰는 옵션

### `-X` : HTTP 메소드 지정

```bash
curl -X GET http://example.com      # 조회 (기본값)
curl -X POST http://example.com     # 생성
curl -X PUT http://example.com      # 수정
curl -X DELETE http://example.com   # 삭제
```

> 💡 `-X`는 `--request`의 축약형입니다.

---

### `-H` : 헤더 추가

```bash
curl -H "Content-Type: application/json" http://example.com
curl -H "Authorization: Bearer TOKEN" http://example.com
```

여러 헤더를 추가하려면 `-H`를 여러 번 사용:

```bash
curl -H "Content-Type: application/json" \
     -H "Authorization: Bearer TOKEN" \
     http://example.com
```

> 💡 `-H`는 `--header`의 축약형입니다.

---

### `-d` : 데이터 전송 (Body)

```bash
curl -d '{"name": "홍길동"}' http://example.com
```

파일에서 데이터 읽기:

```bash
curl -d @data.json http://example.com
```

> 💡 `-d`는 `--data`의 축약형입니다.
> `-d` 사용 시 자동으로 POST 메소드가 됩니다.

---

### `-o` : 결과를 파일로 저장

```bash
curl -o result.json http://example.com/api/data
```

> 💡 `-o`는 `--output`의 축약형입니다.

---

### `-v` : 상세 정보 출력 (디버깅용)

```bash
curl -v http://example.com
```

요청/응답 헤더를 모두 볼 수 있어서 디버깅에 유용합니다.

> 💡 `-v`는 `--verbose`의 축약형입니다.

---

### `-s` : 진행 상황 숨기기

```bash
curl -s http://example.com
```

> 💡 `-s`는 `--silent`의 축약형입니다.

---

## 실전 예제

### JSON POST 요청 (가장 많이 씀)

```bash
curl -X POST http://localhost:5678/webhook/test \
  -H "Content-Type: application/json" \
  -d '{"message": "안녕하세요!"}'
```

해석:
| 부분 | 설명 |
|------|------|
| `-X POST` | POST 메소드 사용 |
| `-H "Content-Type: application/json"` | JSON 형식임을 알림 |
| `-d '{...}'` | 전송할 데이터 |
| `\` | 줄바꿈 (가독성용) |

---

### 인증이 필요한 API 호출

```bash
curl -X GET https://api.example.com/users \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..."
```

---

### 파일 업로드

```bash
curl -X POST http://example.com/upload \
  -F "file=@photo.jpg"
```

> 💡 `-F`는 `--form`의 축약형입니다. (multipart/form-data)

---

## 옵션 요약표

| 옵션 | 전체 이름 | 설명 |
|------|----------|------|
| `-X` | `--request` | HTTP 메소드 지정 |
| `-H` | `--header` | 헤더 추가 |
| `-d` | `--data` | 데이터 전송 (Body) |
| `-o` | `--output` | 파일로 저장 |
| `-v` | `--verbose` | 상세 정보 출력 |
| `-s` | `--silent` | 진행 상황 숨기기 |
| `-F` | `--form` | 폼 데이터/파일 업로드 |
| `-i` | `--include` | 응답 헤더 포함 |
| `-L` | `--location` | 리다이렉트 따라가기 |

---

## 팁

### 1. JSON 예쁘게 보기 (jq 사용)

```bash
curl -s http://example.com/api | jq
```

### 2. 응답 시간 측정

```bash
curl -o /dev/null -s -w "시간: %{time_total}초\n" http://example.com
```

### 3. 윈도우에서는 따옴표 주의

Windows CMD에서는 작은따옴표 대신 큰따옴표 사용:

```cmd
curl -d "{\"message\": \"hello\"}" http://example.com
```

PowerShell에서는:

```powershell
curl -d '{"message": "hello"}' http://example.com
```
