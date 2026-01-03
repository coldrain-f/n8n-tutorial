# 실행 방법: 1. chmod +x request.sh
# 2. ./request.sh
curl -X POST \
http://localhost:5678/webhook-test/[YOUR_PATH] \
-H "Content-Type: application/json" \
-d '{"message": "Hello World!"}'
