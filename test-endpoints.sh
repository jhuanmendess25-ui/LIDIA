#!/bin/bash

# Script de teste para os endpoints do Projeto LIDIA
# Execute: bash test-endpoints.sh

BASE_URL="https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/make-server-ee558f86"
ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhbG5weGNpY2RzemlxbmZ0bWVrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMzA2NTgsImV4cCI6MjA2MjgwNjY1OH0.vWXn6KI0lv7zCPL9bk-AKNaTPfQTzWoBjlBbD_Ky9nU"

echo "========================================="
echo "TESTANDO ENDPOINTS - PROJETO LIDIA"
echo "========================================="
echo ""

echo "1. Testando raiz da API (GET /)..."
curl -s "$BASE_URL/" | jq '.' || echo "Erro ou resposta não-JSON"
echo ""
echo ""

echo "2. Testando health check (GET /health)..."
curl -s "$BASE_URL/health" | jq '.' || echo "Erro ou resposta não-JSON"
echo ""
echo ""

echo "3. Testando inicialização do professor admin (POST /init-professor)..."
curl -s -X POST "$BASE_URL/init-professor" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ANON_KEY" | jq '.' || echo "Erro ou resposta não-JSON"
echo ""
echo ""

echo "4. Testando login do professor admin (POST /login)..."
curl -s -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ANON_KEY" \
  -d '{
    "username": "admin",
    "password": "admin123",
    "type": "professor"
  }' | jq '.' || echo "Erro ou resposta não-JSON"
echo ""
echo ""

echo "5. Testando signup de novo professor (POST /professor-signup)..."
TIMESTAMP=$(date +%s)
curl -s -X POST "$BASE_URL/professor-signup" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ANON_KEY" \
  -d "{
    \"name\": \"Professor Teste $TIMESTAMP\",
    \"email\": \"prof$TIMESTAMP@projetolidia.com\",
    \"username\": \"prof$TIMESTAMP\",
    \"password\": \"senha123\",
    \"specialization\": \"Educação Especial\"
  }" | jq '.' || echo "Erro ou resposta não-JSON"
echo ""
echo ""

echo "6. Testando signup de novo aluno (POST /signup)..."
MATRICULA="2024$TIMESTAMP"
curl -s -X POST "$BASE_URL/signup" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ANON_KEY" \
  -d "{
    \"name\": \"Aluno Teste\",
    \"matricula\": \"$MATRICULA\",
    \"password\": \"senha123\",
    \"grade\": \"7º Ano\",
    \"disabilities\": [\"TEA\"]
  }" | jq '.' || echo "Erro ou resposta não-JSON"
echo ""
echo ""

echo "========================================="
echo "TESTES CONCLUÍDOS"
echo "========================================="
echo ""
echo "Se todos os testes retornaram JSON válido, a API está funcionando!"
echo "Se algum teste retornou '404 Not Found', a função não está deployada."
echo ""
echo "Próximos passos:"
echo "1. Verifique os logs em: https://supabase.com/dashboard/project/ualnpxcicdsziqnftmek/logs"
echo "2. Verifique as funções em: https://supabase.com/dashboard/project/ualnpxcicdsziqnftmek/functions"
echo "3. Se necessário, faça o deploy manual: supabase functions deploy make-server-ee558f86"
echo ""
