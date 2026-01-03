# 01. Webhook → Slack 메시지 보내기

n8n 입문용 가장 쉬운 워크플로우입니다.
OAuth 설정 없이 5분이면 완성할 수 있어요!

## 📋 목표

외부에서 n8n의 Webhook URL을 호출하면 → Slack 채널에 메시지가 전송됩니다.

```
[외부 요청] → [n8n Webhook] → [Slack 채널]
```

## 🛠️ 사전 준비

- n8n 실행 중 (http://localhost:5678)
- Slack 워크스페이스 (무료 계정 OK)

---

## Step 1: Slack Incoming Webhook 만들기

### 1-1. Slack API 페이지 접속

👉 https://api.slack.com/apps

### 1-2. 새 앱 생성

1. **Create an App** 버튼 클릭
2. **From scratch** 선택
3. 설정:
   - App Name: `n8n-bot`
   - Pick a workspace: 본인 워크스페이스 선택
4. **Create App** 클릭

### 1-3. Incoming Webhooks 활성화

1. 왼쪽 메뉴에서 **Incoming Webhooks** 클릭
2. 상단 토글을 **On**으로 변경
3. 페이지 하단 **Add New Webhook** 클릭
4. 메시지를 받을 채널 선택 (예: `#general` 또는 `#test`)
5. **허용** 클릭

### 1-4. Webhook URL 복사

생성된 Webhook URL을 복사해두세요. 이런 형태입니다:

```
https://hooks.slack.com/services/[YOUR_T_ID]/[YOUR_B_ID]/[YOUR_SECRET]
```

실제 URL은 이런 형태입니다: `T01234.../B01234.../abc123...`

> ⚠️ **주의**: 이 URL은 비밀번호처럼 취급하세요! 노출되면 누구나 메시지를 보낼 수 있습니다.

---

## Step 2: n8n 워크플로우 만들기

### 2-1. n8n 접속

브라우저에서 http://localhost:5678 접속

### 2-2. 새 워크플로우 생성

1. 우측 상단 **Add workflow** 클릭 (또는 기존 빈 워크플로우 사용)
2. 워크플로우 이름을 `Webhook to Slack`으로 변경

### 2-3. Webhook 노드 추가 (트리거)

1. 캔버스 중앙의 **+** 버튼 클릭
2. 검색창에 **Webhook** 입력 → **Webhook** 선택
3. 설정:
   - HTTP Method: `POST`
   - Path: `slack-test` (원하는 경로명)
4. 상단의 **Test URL**을 확인 (나중에 사용):
   ```
   http://localhost:5678/webhook-test/slack-test
   ```

### 2-4. HTTP Request 노드 추가 (Slack 전송)

1. Webhook 노드 오른쪽의 **+** 클릭
2. 검색창에 **HTTP Request** 입력 → 선택
3. 설정:
   - **Method**: `POST`
   - **URL**: Step 1에서 복사한 Slack Webhook URL 붙여넣기
   - **Body Content Type**: `JSON`
   - **Body Parameters** → **Add Parameter**:
     - Name: `text`
     - Value: `🎉 n8n에서 보낸 첫 번째 메시지입니다!`

### 2-5. 노드 연결 확인

```
[Webhook] ───→ [HTTP Request]
```

두 노드가 선으로 연결되어 있는지 확인하세요.

---

## Step 3: 테스트하기

### 3-1. 워크플로우 테스트 모드 실행

1. Webhook 노드 클릭
2. 우측 패널에서 **Listen for test event** 클릭
3. n8n이 테스트 요청을 기다리는 상태가 됩니다

### 3-2. 터미널에서 Webhook 호출

새 터미널을 열고 아래 명령어 실행:

```bash
curl -X POST http://localhost:5678/webhook-test/slack-test \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello from curl!"}'
```

### 3-3. 결과 확인

- n8n: 워크플로우가 실행되고 성공 표시
- Slack: 선택한 채널에 메시지 도착! 🎉

---

## Step 4: 워크플로우 활성화 (선택)

테스트가 성공했다면, 실제로 사용하기 위해 활성화합니다:

1. 우측 상단 **Inactive** 토글을 **Active**로 변경
2. 이제 Production URL을 사용할 수 있습니다:
   ```
   http://localhost:5678/webhook/slack-test
   ```

> 📝 **Test URL vs Production URL**
> - Test URL (`/webhook-test/`): 테스트용, 워크플로우 비활성 상태에서 사용
> - Production URL (`/webhook/`): 실제 운영용, 워크플로우 활성화 필요

---

## 🎨 응용: 동적 메시지 보내기

Webhook으로 받은 데이터를 Slack 메시지에 포함시킬 수 있습니다.

### HTTP Request 노드 수정

Body Parameters의 Value를 아래처럼 변경:

```
📬 새 알림!
메시지: {{ $json.body.message }}
시간: {{ $now.format('yyyy-MM-dd HH:mm:ss') }}
```

### 테스트

```bash
curl -X POST http://localhost:5678/webhook-test/slack-test \
  -H "Content-Type: application/json" \
  -d '{"message": "서버 배포가 완료되었습니다!"}'
```

### 결과 (Slack)

```
📬 새 알림!
메시지: 서버 배포가 완료되었습니다!
시간: 2024-01-03 22:30:00
```

---

## 🔧 트러블슈팅

### Slack에 메시지가 안 와요

1. Webhook URL이 정확한지 확인
2. HTTP Request 노드에서 에러 메시지 확인
3. Slack 앱이 채널에 추가되어 있는지 확인

### n8n Webhook이 응답하지 않아요

1. n8n이 실행 중인지 확인 (`docker-compose ps`)
2. 포트 5678이 열려있는지 확인
3. Test 모드에서 "Listen for test event"를 클릭했는지 확인

### curl 명령어가 안 돼요

Windows라면 PowerShell에서:
```powershell
Invoke-WebRequest -Uri "http://localhost:5678/webhook-test/slack-test" -Method POST -ContentType "application/json" -Body '{"message": "Hello!"}'
```

---

## ✅ 완료!

축하합니다! 🎉 첫 번째 n8n 워크플로우를 완성했습니다.

### 배운 것

- Webhook 노드로 외부 요청 받기
- HTTP Request 노드로 외부 API 호출하기
- Slack Incoming Webhook 사용법
- n8n 표현식으로 동적 데이터 처리

### 다음 단계

- [02_Gmail](../02_Gmail/Guide.md) - Gmail → Slack 알림 (OAuth 연동)
