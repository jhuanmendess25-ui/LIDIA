#!/bin/bash

# Script de teste para autenticação de professores - Projeto LIDIA
# Este script testa o fluxo completo de criação e login de professores

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuração
PROJECT_ID="ualnpxcicdsziqnftmek"
BASE_URL="https://${PROJECT_ID}.supabase.co/functions/v1/lidia-api"

# Ler ANON_KEY do arquivo info.tsx
ANON_KEY=$(grep "publicAnonKey" utils/supabase/info.tsx | sed -n "s/.*export const publicAnonKey = ['\"]\\(.*\\)['\"];.*/\\1/p")

if [ -z "$ANON_KEY" ] || [ "$ANON_KEY" = "YOUR_ANON_KEY" ]; then
    echo -e "${RED}❌ ERRO: ANON_KEY não configurada em utils/supabase/info.tsx${NC}"
    exit 1
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Teste de Autenticação de Professores${NC}"
echo -e "${BLUE}  Projeto LIDIA${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Função para fazer requisições
make_request() {
    local method=$1
    local endpoint=$2
    local data=$3
    
    echo -e "${YELLOW}➜ ${method} ${endpoint}${NC}"
    
    if [ -z "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X ${method} \
            "${BASE_URL}${endpoint}" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${ANON_KEY}")
    else
        response=$(curl -s -w "\n%{http_code}" -X ${method} \
            "${BASE_URL}${endpoint}" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${ANON_KEY}" \
            -d "${data}")
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 300 ]; then
        echo -e "${GREEN}✓ Status: ${http_code}${NC}"
        echo "$body" | jq '.' 2>/dev/null || echo "$body"
    else
        echo -e "${RED}✗ Status: ${http_code}${NC}"
        echo "$body" | jq '.' 2>/dev/null || echo "$body"
        return 1
    fi
    echo ""
}

# Teste 1: Health Check
echo -e "${BLUE}[1/7] Verificando saúde da API...${NC}"
make_request "GET" "/health"
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ API não está respondendo. Verifique o deploy.${NC}"
    exit 1
fi

# Teste 2: Info da API
echo -e "${BLUE}[2/7] Verificando informações da API...${NC}"
make_request "GET" "/"

# Teste 3: Inicializar professor padrão (admin)
echo -e "${BLUE}[3/7] Inicializando professor padrão (admin)...${NC}"
make_request "POST" "/init-professor"

# Teste 4: Login com professor padrão
echo -e "${BLUE}[4/7] Testando login com professor padrão...${NC}"
admin_login=$(curl -s -X POST \
    "${BASE_URL}/login" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${ANON_KEY}" \
    -d '{
        "username": "admin",
        "password": "admin123",
        "type": "professor"
    }')

admin_token=$(echo "$admin_login" | jq -r '.accessToken // empty')

if [ -z "$admin_token" ]; then
    echo -e "${RED}✗ Falha no login do admin${NC}"
    echo "$admin_login" | jq '.'
    echo -e "${YELLOW}⚠ Continuando com outros testes...${NC}\n"
else
    echo -e "${GREEN}✓ Login do admin bem-sucedido${NC}"
    echo "$admin_login" | jq '.'
    echo ""
fi

# Teste 5: Criar novo professor
echo -e "${BLUE}[5/7] Criando novo professor de teste...${NC}"
timestamp=$(date +%s)
test_username="teste${timestamp}"
test_email="${test_username}@projetolidia.com"
test_password="senha123"

signup_data="{
    \"name\": \"Professor Teste ${timestamp}\",
    \"email\": \"${test_email}\",
    \"username\": \"${test_username}\",
    \"password\": \"${test_password}\",
    \"specialization\": \"Teste Automatizado\"
}"

signup_response=$(curl -s -X POST \
    "${BASE_URL}/professor-signup" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${ANON_KEY}" \
    -d "${signup_data}")

echo "$signup_response" | jq '.'

signup_success=$(echo "$signup_response" | jq -r '.success // false')

if [ "$signup_success" = "true" ]; then
    echo -e "${GREEN}✓ Professor criado com sucesso${NC}\n"
    
    # Teste 6: Login com novo professor
    echo -e "${BLUE}[6/7] Testando login com novo professor...${NC}"
    sleep 2  # Aguarda processamento
    
    login_data="{
        \"username\": \"${test_username}\",
        \"password\": \"${test_password}\",
        \"type\": \"professor\"
    }"
    
    login_response=$(curl -s -X POST \
        "${BASE_URL}/login" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${ANON_KEY}" \
        -d "${login_data}")
    
    echo "$login_response" | jq '.'
    
    login_success=$(echo "$login_response" | jq -r '.success // false')
    
    if [ "$login_success" = "true" ]; then
        echo -e "${GREEN}✓ Login bem-sucedido${NC}\n"
        
        # Teste 7: Tentar criar mesmo professor novamente (deve falhar)
        echo -e "${BLUE}[7/7] Testando duplicação (deve falhar)...${NC}"
        duplicate_response=$(curl -s -X POST \
            "${BASE_URL}/professor-signup" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${ANON_KEY}" \
            -d "${signup_data}")
        
        echo "$duplicate_response" | jq '.'
        
        duplicate_error=$(echo "$duplicate_response" | jq -r '.error // empty')
        
        if [ -n "$duplicate_error" ]; then
            echo -e "${GREEN}✓ Validação de duplicação funcionando${NC}\n"
        else
            echo -e "${RED}✗ Validação de duplicação falhou${NC}\n"
        fi
    else
        echo -e "${RED}✗ Falha no login do novo professor${NC}\n"
    fi
else
    echo -e "${RED}✗ Falha ao criar professor${NC}\n"
fi

# Resumo
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Resumo dos Testes${NC}"
echo -e "${BLUE}========================================${NC}"

echo -e "\n${YELLOW}Credenciais de Teste Criadas:${NC}"
echo -e "  Username: ${test_username}"
echo -e "  Email: ${test_email}"
echo -e "  Password: ${test_password}"

echo -e "\n${YELLOW}Credenciais do Admin Padrão:${NC}"
echo -e "  Username: admin"
echo -e "  Password: admin123"

echo -e "\n${YELLOW}URL Base da API:${NC}"
echo -e "  ${BASE_URL}"

echo -e "\n${GREEN}✓ Testes concluídos!${NC}\n"

echo -e "${YELLOW}Para testar no navegador:${NC}"
echo -e "  1. Abra a aplicação"
echo -e "  2. Selecione 'Professor' no tipo de login"
echo -e "  3. Clique em 'Criar Conta de Professor'"
echo -e "  4. Use um email terminando em @projetolidia.com"
echo -e "  5. Após criar, faça login com o username (parte antes do @)"
echo ""
