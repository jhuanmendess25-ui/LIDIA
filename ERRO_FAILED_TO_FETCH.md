# 🚨 ERRO: Failed to Fetch - SOLUÇÃO RÁPIDA

## O QUE ESTÁ ACONTECENDO?

Você está vendo estes erros:
```
Login error: TypeError: Failed to fetch
Professor signup error: TypeError: Failed to fetch
```

**Motivo**: A Edge Function `lidia-api` não está acessível.

---

## ✅ SOLUÇÃO EM 3 PASSOS

### 1️⃣ Verificar o Problema

Execute o script de diagnóstico:

```bash
chmod +x check-api.sh
./check-api.sh
```

Este script vai:
- ✅ Testar se a API está online
- ✅ Testar todos os endpoints
- ✅ Diagnosticar o problema
- ✅ Sugerir a solução

### 2️⃣ Fazer Deploy da Função

```bash
# Login
npx supabase login

# Linkar projeto
npx supabase link --project-ref ualnpxcicdsziqnftmek

# Deploy
npx supabase functions deploy lidia-api
```

### 3️⃣ Verificar se Funcionou

```bash
# Executar script de verificação novamente
./check-api.sh

# Ou testar manualmente
curl https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api
```

**Resposta esperada**:
```json
{
  "status": "ok",
  "message": "Projeto LIDIA API - lidia-api",
  "version": "3.0"
}
```

---

## 🧪 TESTE NO NAVEGADOR

Após o deploy:

1. Abra a aplicação
2. Selecione "Professor"
3. Faça login com:
   - **Username**: `admin`
   - **Password**: `admin123`
4. ✅ Deve funcionar!

---

## 📖 DOCUMENTAÇÃO COMPLETA

Para mais detalhes e troubleshooting avançado, veja:
- **`DEPLOY_URGENTE.md`** - Guia completo de deploy
- **`check-api.sh`** - Script de diagnóstico automático

---

## 🆘 AINDA NÃO FUNCIONOU?

### Opção A: Verificar Dashboard do Supabase

1. Acesse: https://supabase.com/dashboard/project/ualnpxcicdsziqnftmek/functions
2. Verifique se a função `lidia-api` está listada
3. Se não estiver, faça o deploy novamente

### Opção B: Ver Logs de Erro

1. Abra o Console do navegador (F12)
2. Vá para a aba "Network"
3. Tente fazer login
4. Veja se o request para `lidia-api` está falhando
5. Copie o erro e verifique a causa

### Opção C: Testar Endpoints Individualmente

```bash
# Teste 1: API raiz
curl https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api

# Teste 2: Health check
curl https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api/health

# Teste 3: Login
curl -X POST https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api/login \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhbG5weGNpY2RzemlxbmZ0bWVrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzNTY0OTMsImV4cCI6MjA3OTkzMjQ5M30.QjACPOio1fUXjXvyxMOb-3Dku9cMLgE3MJHoqGvJhVw" \
  -d '{"username":"admin","password":"admin123","type":"professor"}'
```

Se algum desses comandos falhar, a função não está deployada.

---

## 📊 CHECKLIST RÁPIDO

- [ ] Executei `./check-api.sh` para diagnosticar
- [ ] Fiz login no Supabase CLI (`npx supabase login`)
- [ ] Linkei o projeto (`npx supabase link`)
- [ ] Deployei a função (`npx supabase functions deploy lidia-api`)
- [ ] Testei o endpoint raiz com curl
- [ ] Testei login no navegador
- [ ] ✅ **NÃO** vejo mais "Failed to fetch"

---

## ✅ SUCESSO!

Se tudo funcionou:
- ✅ Login com admin/admin123 funciona
- ✅ Criação de contas funciona
- ✅ Dashboard carrega
- ✅ Sem erros no console

**Próximo passo**: Execute os testes automatizados para validar tudo:

```bash
chmod +x test-professor-auth.sh
./test-professor-auth.sh
```

---

**Projeto LIDIA** - Sistema de Apoio a Alunos com TEA  
Solução para erro "Failed to fetch" - 28/11/2025 💚
