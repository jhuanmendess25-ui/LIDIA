#!/bin/bash

# Script de teste para lidia-api Edge Function
# Projeto LIDIA - Sistema de Apoio para Alunos com TEA e TOD

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base URL
BASE_URL="https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api"

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}Testando LIDIA API Edge Function${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Teste 1: Health Check
echo -e "${YELLOW}Teste 1: Health Check${NC}"
echo "GET $BASE_URL/health"
echo ""
RESPONSE=$(curl -s "$BASE_URL/health")
echo "Resposta: $RESPONSE"
if echo "$RESPONSE" | grep -q '"status":"ok"'; then
    echo -e "${GREEN}✅ Health check passou!${NC}"
else
    echo -e "${RED}❌ Health check falhou!${NC}"
fi
echo ""
echo "---"
echo ""

# Teste 2: API Info
echo -e "${YELLOW}Teste 2: Informações da API${NC}"
echo "GET $BASE_URL/"
echo ""
RESPONSE=$(curl -s "$BASE_URL/")
echo "Resposta: $RESPONSE"
if echo "$RESPONSE" | grep -q '"status":"ok"'; then
    echo -e "${GREEN}✅ API info passou!${NC}"
else
    echo -e "${RED}❌ API info falhou!${NC}"
fi
echo ""
echo "---"
echo ""

# Teste 3: Inicializar Professor Admin
echo -e "${YELLOW}Teste 3: Inicializar Conta Admin${NC}"
echo "POST $BASE_URL/init-professor"
echo ""
RESPONSE=$(curl -s -X POST "$BASE_URL/init-professor" \
  -H "Content-Type: application/json")
echo "Resposta: $RESPONSE"
if echo "$RESPONSE" | grep -q '"success":true'; then
    echo -e "${GREEN}✅ Init professor passou!${NC}"
else
    echo -e "${YELLOW}⚠️  Admin pode já existir (esperado)${NC}"
fi
echo ""
echo "---"
echo ""

# Teste 4: Criar Conta de Professor
echo -e "${YELLOW}Teste 4: Criar Conta de Professor${NC}"
echo "POST $BASE_URL/professor-signup"
echo ""
TIMESTAMP=$(date +%s)
USERNAME="prof_teste_$TIMESTAMP"
EMAIL="teste_$TIMESTAMP@projetolidia.com"

RESPONSE=$(curl -s -X POST "$BASE_URL/professor-signup" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"Professor Teste $TIMESTAMP\",
    \"email\": \"$EMAIL\",
    \"username\": \"$USERNAME\",
    \"password\": \"senha123\",
    \"specialization\": \"Educação Especial\"
  }")
echo "Resposta: $RESPONSE"
if echo "$RESPONSE" | grep -q '"success":true'; then
    echo -e "${GREEN}✅ Cadastro de professor passou!${NC}"
    echo -e "${GREEN}Username criado: $USERNAME${NC}"
    CREATED_USERNAME="$USERNAME"
else
    echo -e "${RED}❌ Cadastro de professor falhou!${NC}"
    echo -e "${RED}Detalhes: $RESPONSE${NC}"
fi
echo ""
echo "---"
echo ""

# Teste 5: Login com Professor
echo -e "${YELLOW}Teste 5: Login com Professor${NC}"
echo "POST $BASE_URL/login"
echo ""
RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123",
    "type": "professor"
  }')
echo "Resposta: $RESPONSE"
if echo "$RESPONSE" | grep -q '"success":true'; then
    echo -e "${GREEN}✅ Login de professor passou!${NC}"
    ACCESS_TOKEN=$(echo "$RESPONSE" | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)
    echo -e "${GREEN}Access token obtido (primeiros 50 chars): ${ACCESS_TOKEN:0:50}...${NC}"
else
    echo -e "${RED}❌ Login de professor falhou!${NC}"
    echo -e "${RED}Detalhes: $RESPONSE${NC}"
fi
echo ""
echo "---"
echo ""

# Teste 6: Criar Conta de Aluno
echo -e "${YELLOW}Teste 6: Criar Conta de Aluno${NC}"
echo "POST $BASE_URL/signup"
echo ""
MATRICULA="2024$TIMESTAMP"

RESPONSE=$(curl -s -X POST "$BASE_URL/signup" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"Aluno Teste $TIMESTAMP\",
    \"matricula\": \"$MATRICULA\",
    \"password\": \"senha123\",
    \"grade\": \"7º Ano\",
    \"disabilities\": [\"TEA\", \"TOD\"]
  }")
echo "Resposta: $RESPONSE"
if echo "$RESPONSE" | grep -q '"success":true'; then
    echo -e "${GREEN}✅ Cadastro de aluno passou!${NC}"
    echo -e "${GREEN}Matrícula criada: $MATRICULA${NC}"
else
    echo -e "${RED}❌ Cadastro de aluno falhou!${NC}"
    echo -e "${RED}Detalhes: $RESPONSE${NC}"
fi
echo ""
echo "---"
echo ""

# Teste 7: Login com Aluno
echo -e "${YELLOW}Teste 7: Login com Aluno${NC}"
echo "POST $BASE_URL/login"
echo ""
RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d "{
    \"username\": \"$MATRICULA\",
    \"password\": \"senha123\",
    \"type\": \"student\"
  }")
echo "Resposta: $RESPONSE"
if echo "$RESPONSE" | grep -q '"success":true'; then
    echo -e "${GREEN}✅ Login de aluno passou!${NC}"
else
    echo -e "${RED}❌ Login de aluno falhou!${NC}"
    echo -e "${RED}Detalhes: $RESPONSE${NC}"
fi
echo ""
echo "---"
echo ""

# Teste 8: Obter Perfil de Aluno
echo -e "${YELLOW}Teste 8: Obter Perfil de Aluno${NC}"
echo "GET $BASE_URL/student/$MATRICULA"
echo ""
RESPONSE=$(curl -s "$BASE_URL/student/$MATRICULA")
echo "Resposta: $RESPONSE"
if echo "$RESPONSE" | grep -q '"success":true'; then
    echo -e "${GREEN}✅ Obter perfil de aluno passou!${NC}"
else
    echo -e "${RED}❌ Obter perfil de aluno falhou!${NC}"
    echo -e "${RED}Detalhes: $RESPONSE${NC}"
fi
echo ""
echo "---"
echo ""

# Teste 9: Endpoint Inexistente (404)
echo -e "${YELLOW}Teste 9: Endpoint Inexistente (Esperado 404)${NC}"
echo "GET $BASE_URL/endpoint-inexistente"
echo ""
RESPONSE=$(curl -s "$BASE_URL/endpoint-inexistente")
echo "Resposta: $RESPONSE"
if echo "$RESPONSE" | grep -q '"error":"Route not found"'; then
    echo -e "${GREEN}✅ Handler 404 funcionando corretamente!${NC}"
else
    echo -e "${RED}❌ Handler 404 não está funcionando!${NC}"
fi
echo ""
echo "---"
echo ""

# Resumo
echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}Resumo dos Testes${NC}"
echo -e "${BLUE}================================${NC}"
echo ""
echo -e "${GREEN}Todos os testes foram executados!${NC}"
echo ""
echo "Para verificar os logs no Supabase:"
echo "https://supabase.com/dashboard/project/ualnpxcicdsziqnftmek/logs"
echo ""
echo "Credenciais de teste criadas:"
echo "  Professor Admin: admin / admin123"
if [ ! -z "$CREATED_USERNAME" ]; then
    echo "  Professor Teste: $CREATED_USERNAME / senha123"
fi
if [ ! -z "$MATRICULA" ]; then
    echo "  Aluno Teste: $MATRICULA / senha123"
fi
echo ""
echo -e "${YELLOW}Nota: Se algum teste falhou, verifique:${NC}"
echo "  1. Se a função foi deployada no Supabase"
echo "  2. Os logs no Dashboard do Supabase"
echo "  3. Se as variáveis de ambiente estão corretas"
echo ""
