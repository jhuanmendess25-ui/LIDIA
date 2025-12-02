#!/bin/bash

# Script de Verificação da API
# Diagnostica problemas de conexão com a Edge Function

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_ID="ualnpxcicdsziqnftmek"
BASE_URL="https://${PROJECT_ID}.supabase.co/functions/v1/lidia-api"
ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhbG5weGNpY2RzemlxbmZ0bWVrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzNTY0OTMsImV4cCI6MjA3OTkzMjQ5M30.QjACPOio1fUXjXvyxMOb-3Dku9cMLgE3MJHoqGvJhVw"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Diagnóstico da API - Projeto LIDIA${NC}"
echo -e "${BLUE}========================================${NC}\n"

TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0

# Função para verificar
check() {
    local name=$1
    local command=$2
    local expected=$3
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    echo -e "${YELLOW}[$TOTAL_CHECKS] $name${NC}"
    
    result=$(eval "$command" 2>&1)
    exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        if [[ "$result" == *"$expected"* ]]; then
            echo -e "${GREEN}✓ PASSOU${NC}"
            echo -e "  Resposta: ${result:0:100}"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
        else
            echo -e "${RED}✗ FALHOU - Resposta inesperada${NC}"
            echo -e "  Esperado: $expected"
            echo -e "  Recebido: ${result:0:200}"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
        fi
    else
        echo -e "${RED}✗ FALHOU - Erro na conexão${NC}"
        echo -e "  Erro: ${result:0:200}"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
    echo ""
}

# VERIFICAÇÃO 1: Endpoint raiz
echo -e "${BLUE}=== Verificações Básicas ===${NC}\n"

check "1. API Raiz (GET /)" \
    "curl -s -m 5 '${BASE_URL}'" \
    "Projeto LIDIA"

# VERIFICAÇÃO 2: Health check
check "2. Health Check (GET /health)" \
    "curl -s -m 5 '${BASE_URL}/health'" \
    "ok"

# VERIFICAÇÃO 3: Login com credenciais padrão
echo -e "${BLUE}=== Verificações de Autenticação ===${NC}\n"

check "3. Login Professor Padrão (POST /login)" \
    "curl -s -m 10 -X POST '${BASE_URL}/login' -H 'Content-Type: application/json' -H 'Authorization: Bearer ${ANON_KEY}' -d '{\"username\":\"admin\",\"password\":\"admin123\",\"type\":\"professor\"}'" \
    "success"

# VERIFICAÇÃO 4: Inicialização de professor
check "4. Inicializar Professor Padrão (POST /init-professor)" \
    "curl -s -m 10 -X POST '${BASE_URL}/init-professor' -H 'Content-Type: application/json' -H 'Authorization: Bearer ${ANON_KEY}'" \
    "success"

# VERIFICAÇÃO 5: Teste de erro (login inválido)
check "5. Teste de Erro - Login Inválido" \
    "curl -s -m 10 -X POST '${BASE_URL}/login' -H 'Content-Type: application/json' -H 'Authorization: Bearer ${ANON_KEY}' -d '{\"username\":\"inexistente\",\"password\":\"errado\",\"type\":\"professor\"}'" \
    "error"

# VERIFICAÇÃO 6: DNS Resolution
echo -e "${BLUE}=== Verificações de Conectividade ===${NC}\n"

TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
echo -e "${YELLOW}[$TOTAL_CHECKS] DNS Resolution${NC}"
if host "${PROJECT_ID}.supabase.co" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ PASSOU - DNS resolvido corretamente${NC}"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    echo -e "${RED}✗ FALHOU - Não foi possível resolver DNS${NC}"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi
echo ""

# VERIFICAÇÃO 7: Conectividade HTTPS
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
echo -e "${YELLOW}[$TOTAL_CHECKS] Conectividade HTTPS${NC}"
if curl -s -m 5 -o /dev/null -w "%{http_code}" "https://${PROJECT_ID}.supabase.co" | grep -q "200\|301\|302"; then
    echo -e "${GREEN}✓ PASSOU - HTTPS acessível${NC}"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    echo -e "${RED}✗ FALHOU - HTTPS não acessível${NC}"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi
echo ""

# VERIFICAÇÃO 8: Configuração local
echo -e "${BLUE}=== Verificações de Configuração ===${NC}\n"

TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
echo -e "${YELLOW}[$TOTAL_CHECKS] Arquivo de Configuração${NC}"
if [ -f "utils/supabase/info.tsx" ]; then
    if grep -q "ualnpxcicdsziqnftmek" "utils/supabase/info.tsx" && ! grep -q "YOUR_PROJECT_ID" "utils/supabase/info.tsx"; then
        echo -e "${GREEN}✓ PASSOU - Configuração válida${NC}"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        echo -e "${RED}✗ FALHOU - Configuração inválida ou não atualizada${NC}"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
else
    echo -e "${RED}✗ FALHOU - Arquivo de configuração não encontrado${NC}"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi
echo ""

# VERIFICAÇÃO 9: Edge Function deployada
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
echo -e "${YELLOW}[$TOTAL_CHECKS] Edge Function Deployada${NC}"
if [ -d "supabase/functions/lidia-api" ]; then
    echo -e "${GREEN}✓ PASSOU - Pasta da função existe localmente${NC}"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
    
    # Verificar se o arquivo principal existe
    if [ -f "supabase/functions/lidia-api/index.ts" ]; then
        echo -e "  ${GREEN}✓${NC} Arquivo index.ts encontrado"
    else
        echo -e "  ${RED}✗${NC} Arquivo index.ts NÃO encontrado"
    fi
else
    echo -e "${RED}✗ FALHOU - Pasta da função não existe${NC}"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi
echo ""

# Resumo
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Resumo do Diagnóstico${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "Total de verificações: ${TOTAL_CHECKS}"
echo -e "${GREEN}Passou: ${PASSED_CHECKS}${NC}"
echo -e "${RED}Falhou: ${FAILED_CHECKS}${NC}\n"

PASS_RATE=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))
echo -e "Taxa de sucesso: ${PASS_RATE}%\n"

# Diagnóstico e recomendações
if [ $FAILED_CHECKS -eq 0 ]; then
    echo -e "${GREEN}✓ TUDO FUNCIONANDO PERFEITAMENTE!${NC}"
    echo -e "\nA API está operacional e todos os endpoints estão respondendo corretamente."
    echo -e "\n${GREEN}Próximos passos:${NC}"
    echo -e "1. Abra a aplicação no navegador"
    echo -e "2. Faça login com: admin / admin123"
    echo -e "3. Comece a usar o sistema!"
else
    echo -e "${RED}✗ PROBLEMAS DETECTADOS${NC}\n"
    
    echo -e "${YELLOW}Diagnóstico:${NC}"
    
    # Verificar qual é o problema principal
    if ! curl -s -m 5 "${BASE_URL}" > /dev/null 2>&1; then
        echo -e "\n${RED}⚠️  PROBLEMA CRÍTICO: Edge Function não está acessível${NC}"
        echo -e "\n${YELLOW}Possíveis causas:${NC}"
        echo -e "1. Edge Function não foi deployada"
        echo -e "2. Edge Function foi deletada"
        echo -e "3. Projeto Supabase inativo"
        
        echo -e "\n${GREEN}SOLUÇÃO URGENTE:${NC}"
        echo -e "Execute estes comandos:"
        echo -e ""
        echo -e "  ${BLUE}npx supabase login${NC}"
        echo -e "  ${BLUE}npx supabase link --project-ref ualnpxcicdsziqnftmek${NC}"
        echo -e "  ${BLUE}npx supabase functions deploy lidia-api${NC}"
        echo -e ""
        echo -e "Depois execute este script novamente para verificar."
        
    elif ! grep -q "ualnpxcicdsziqnftmek" "utils/supabase/info.tsx" 2>/dev/null; then
        echo -e "\n${RED}⚠️  Configuração local incorreta${NC}"
        echo -e "\n${GREEN}SOLUÇÃO:${NC}"
        echo -e "Verifique o arquivo utils/supabase/info.tsx"
        
    else
        echo -e "\n${YELLOW}⚠️  Alguns endpoints não estão funcionando${NC}"
        echo -e "\n${GREEN}SOLUÇÃO:${NC}"
        echo -e "1. Refaça o deploy da função:"
        echo -e "   ${BLUE}npx supabase functions deploy lidia-api${NC}"
        echo -e ""
        echo -e "2. Aguarde 30 segundos"
        echo -e ""
        echo -e "3. Execute este script novamente"
    fi
    
    echo -e "\n${YELLOW}Documentação completa:${NC}"
    echo -e "Leia o arquivo: ${BLUE}DEPLOY_URGENTE.md${NC}"
fi

echo -e "\n${BLUE}========================================${NC}\n"

exit $FAILED_CHECKS
