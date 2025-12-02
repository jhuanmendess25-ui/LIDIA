#!/bin/bash

# Script de teste completo de erros - Criação de Professor
# Testa TODOS os cenários de erro possíveis

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuração
PROJECT_ID="ualnpxcicdsziqnftmek"
BASE_URL="https://${PROJECT_ID}.supabase.co/functions/v1/lidia-api"
ANON_KEY=$(grep "publicAnonKey" utils/supabase/info.tsx | sed -n "s/.*export const publicAnonKey = ['\"]\\(.*\\)['\"];.*/\\1/p")

if [ -z "$ANON_KEY" ] || [ "$ANON_KEY" = "YOUR_ANON_KEY" ]; then
    echo -e "${RED}❌ ERRO: ANON_KEY não configurada${NC}"
    exit 1
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Teste Completo de Erros${NC}"
echo -e "${BLUE}  Criação de Conta de Professor${NC}"
echo -e "${BLUE}========================================${NC}\n"

TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Função para fazer requisições
test_signup() {
    local test_name=$1
    local data=$2
    local expected_error=$3
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    echo -e "${CYAN}[Teste $TOTAL_TESTS] ${test_name}${NC}"
    
    response=$(curl -s -X POST \
        "${BASE_URL}/professor-signup" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${ANON_KEY}" \
        -d "${data}")
    
    error=$(echo "$response" | jq -r '.error // empty')
    success=$(echo "$response" | jq -r '.success // false')
    
    if [ "$success" = "true" ]; then
        if [ -n "$expected_error" ]; then
            echo -e "${RED}✗ FALHOU: Deveria retornar erro mas foi bem-sucedido${NC}"
            echo "$response" | jq '.'
            FAILED_TESTS=$((FAILED_TESTS + 1))
        else
            echo -e "${GREEN}✓ PASSOU: Cadastro bem-sucedido${NC}"
            PASSED_TESTS=$((PASSED_TESTS + 1))
        fi
    else
        if [ -n "$expected_error" ]; then
            if [[ "$error" == *"$expected_error"* ]]; then
                echo -e "${GREEN}✓ PASSOU: Erro esperado recebido${NC}"
                echo -e "${YELLOW}   Erro: $error${NC}"
                PASSED_TESTS=$((PASSED_TESTS + 1))
            else
                echo -e "${RED}✗ FALHOU: Erro diferente do esperado${NC}"
                echo -e "${YELLOW}   Esperado: $expected_error${NC}"
                echo -e "${YELLOW}   Recebido: $error${NC}"
                FAILED_TESTS=$((FAILED_TESTS + 1))
            fi
        else
            echo -e "${RED}✗ FALHOU: Erro inesperado${NC}"
            echo -e "${YELLOW}   Erro: $error${NC}"
            FAILED_TESTS=$((FAILED_TESTS + 1))
        fi
    fi
    echo ""
}

# TESTE 1: Campos vazios
echo -e "${BLUE}=== GRUPO 1: Validação de Campos Obrigatórios ===${NC}\n"

test_signup "1.1 - Sem nome" \
    '{"email":"teste@projetolidia.com","username":"teste","password":"senha123"}' \
    "Nome"

test_signup "1.2 - Sem email" \
    '{"name":"Teste Nome","username":"teste","password":"senha123"}' \
    "Email"

test_signup "1.3 - Sem username" \
    '{"name":"Teste Nome","email":"teste@projetolidia.com","password":"senha123"}' \
    "Username"

test_signup "1.4 - Sem senha" \
    '{"name":"Teste Nome","email":"teste@projetolidia.com","username":"teste"}' \
    "Senha"

test_signup "1.5 - Nome muito curto (2 chars)" \
    '{"name":"Ab","email":"teste@projetolidia.com","username":"teste","password":"senha123"}' \
    "mínimo 3 caracteres"

test_signup "1.6 - Username muito curto (2 chars)" \
    '{"name":"Teste Nome","email":"te@projetolidia.com","username":"te","password":"senha123"}' \
    "mínimo 3 caracteres"

test_signup "1.7 - Senha muito curta (5 chars)" \
    '{"name":"Teste Nome","email":"teste@projetolidia.com","username":"teste","password":"12345"}' \
    "mínimo 6 caracteres"

# TESTE 2: Validação de email
echo -e "${BLUE}=== GRUPO 2: Validação de Email ===${NC}\n"

test_signup "2.1 - Email sem @" \
    '{"name":"Teste Nome","email":"testeprojetolidia.com","username":"teste","password":"senha123"}' \
    "inválido"

test_signup "2.2 - Email sem domínio" \
    '{"name":"Teste Nome","email":"teste@","username":"teste","password":"senha123"}' \
    "inválido"

test_signup "2.3 - Email com domínio errado (@gmail.com)" \
    '{"name":"Teste Nome","email":"teste@gmail.com","username":"teste","password":"senha123"}' \
    "@projetolidia.com"

test_signup "2.4 - Email com domínio errado (@hotmail.com)" \
    '{"name":"Teste Nome","email":"teste@hotmail.com","username":"teste","password":"senha123"}' \
    "@projetolidia.com"

test_signup "2.5 - Email com subdomínio errado" \
    '{"name":"Teste Nome","email":"teste@outro.projetolidia.com","username":"teste","password":"senha123"}' \
    "@projetolidia.com"

# TESTE 3: Criar conta válida
echo -e "${BLUE}=== GRUPO 3: Criação de Conta Válida ===${NC}\n"

TIMESTAMP=$(date +%s)
VALID_EMAIL="teste${TIMESTAMP}@projetolidia.com"
VALID_USERNAME="teste${TIMESTAMP}"

test_signup "3.1 - Conta válida completa" \
    "{\"name\":\"Professor Teste ${TIMESTAMP}\",\"email\":\"${VALID_EMAIL}\",\"username\":\"${VALID_USERNAME}\",\"password\":\"senha123\",\"specialization\":\"Teste\"}" \
    ""

# TESTE 4: Duplicação
echo -e "${BLUE}=== GRUPO 4: Validação de Duplicação ===${NC}\n"

test_signup "4.1 - Mesmo username (duplicado)" \
    "{\"name\":\"Professor Teste 2\",\"email\":\"outro${TIMESTAMP}@projetolidia.com\",\"username\":\"${VALID_USERNAME}\",\"password\":\"senha123\"}" \
    "já está cadastrado"

test_signup "4.2 - Mesmo email (duplicado)" \
    "{\"name\":\"Professor Teste 3\",\"email\":\"${VALID_EMAIL}\",\"username\":\"outro${TIMESTAMP}\",\"password\":\"senha123\"}" \
    "já está cadastrado"

# TESTE 5: Dados inválidos
echo -e "${BLUE}=== GRUPO 5: Validação de Tipos de Dados ===${NC}\n"

test_signup "5.1 - Nome como número" \
    '{"name":12345,"email":"teste2@projetolidia.com","username":"teste2","password":"senha123"}' \
    "Nome"

test_signup "5.2 - Email como número" \
    '{"name":"Teste Nome","email":12345,"username":"teste2","password":"senha123"}' \
    "Email"

test_signup "5.3 - JSON inválido" \
    'invalid json {name:test}' \
    "inválido"

# TESTE 6: Normalização
echo -e "${BLUE}=== GRUPO 6: Normalização de Dados ===${NC}\n"

TIMESTAMP2=$(date +%s)
test_signup "6.1 - Email com maiúsculas" \
    "{\"name\":\"Teste Maiuscula\",\"email\":\"TESTE${TIMESTAMP2}@PROJETOLIDIA.COM\",\"username\":\"teste${TIMESTAMP2}\",\"password\":\"senha123\"}" \
    ""

sleep 1
TIMESTAMP3=$(date +%s)
test_signup "6.2 - Username com maiúsculas" \
    "{\"name\":\"Teste Username\",\"email\":\"teste${TIMESTAMP3}@projetolidia.com\",\"username\":\"TESTE${TIMESTAMP3}\",\"password\":\"senha123\"}" \
    ""

sleep 1
TIMESTAMP4=$(date +%s)
test_signup "6.3 - Espaços extras no nome" \
    "{\"name\":\"  Teste Espacos  \",\"email\":\"teste${TIMESTAMP4}@projetolidia.com\",\"username\":\"teste${TIMESTAMP4}\",\"password\":\"senha123\"}" \
    ""

# Resumo
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Resumo dos Testes${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "Total de testes: ${TOTAL_TESTS}"
echo -e "${GREEN}Testes passou: ${PASSED_TESTS}${NC}"
echo -e "${RED}Testes falharam: ${FAILED_TESTS}${NC}\n"

PASS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
echo -e "Taxa de sucesso: ${PASS_RATE}%\n"

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}✓ TODOS OS TESTES PASSARAM!${NC}\n"
    exit 0
else
    echo -e "${RED}✗ ALGUNS TESTES FALHARAM${NC}\n"
    exit 1
fi
