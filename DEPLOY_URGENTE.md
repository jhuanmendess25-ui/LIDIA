# 🚨 DEPLOY URGENTE - Erro "Failed to fetch"

## ⚠️ PROBLEMA

Você está recebendo os erros:
```
Login error: TypeError: Failed to fetch
Professor signup error: TypeError: Failed to fetch
```

**Causa**: A Edge Function `lidia-api` NÃO está deployada ou não está acessível.

---

## ✅ SOLUÇÃO RÁPIDA (3 passos)

### Passo 1: Login no Supabase

```bash
npx supabase login
```

Se solicitado, autorize no navegador.

### Passo 2: Linkar o Projeto

```bash
npx supabase link --project-ref ualnpxcicdsziqnftmek
```

Quando solicitado:
- Digite a **senha do banco de dados** (você deve ter salvo isso)
- Se não lembrar, pode redefinir no dashboard do Supabase

### Passo 3: Deploy da Função

```bash
npx supabase functions deploy lidia-api
```

Aguarde a mensagem de sucesso:
```
Deployed Function lidia-api with version xxxxx
```

---

## 🧪 TESTAR SE FUNCIONOU

### Teste 1: Via curl (Terminal)

```bash
curl https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api
```

**Resposta esperada** (deve retornar JSON):
```json
{
  "status": "ok",
  "message": "Projeto LIDIA API - lidia-api",
  "version": "3.0"
}
```

### Teste 2: Health Check

```bash
curl https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api/health
```

**Resposta esperada**:
```json
{
  "status": "ok",
  "timestamp": "2025-11-28T...",
  "supabase": "connected",
  "kv": "connected"
}
```

### Teste 3: Teste de Login (com credenciais padrão)

```bash
curl -X POST https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api/login \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhbG5weGNpY2RzemlxbmZ0bWVrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzNTY0OTMsImV4cCI6MjA3OTkzMjQ5M30.QjACPOio1fUXjXvyxMOb-3Dku9cMLgE3MJHoqGvJhVw" \
  -d '{"username":"admin","password":"admin123","type":"professor"}'
```

**Resposta esperada**:
```json
{
  "success": true,
  "accessToken": "...",
  "userId": "...",
  "message": "Login bem-sucedido"
}
```

---

## 🌐 TESTAR NO NAVEGADOR

1. Abra a aplicação
2. Selecione "Professor"
3. Tente fazer login com:
   - **Username**: `admin`
   - **Senha**: `admin123`
4. ✅ Deve funcionar!

---

## 🔍 TROUBLESHOOTING

### Erro 1: "npx: command not found"

**Solução**: Instale o Node.js:
- Download: https://nodejs.org/
- Versão recomendada: 18.x ou superior

### Erro 2: "Supabase CLI not found"

**Solução**: Instale o Supabase CLI:
```bash
npm install -g supabase
```

### Erro 3: "Project not linked"

**Solução**: Execute novamente:
```bash
npx supabase link --project-ref ualnpxcicdsziqnftmek
```

### Erro 4: "Invalid project ref"

**Verificações**:
1. Acesse: https://supabase.com/dashboard/projects
2. Verifique se o projeto `ualnpxcicdsziqnftmek` existe
3. Se não existir, crie um novo projeto e atualize o arquivo `/utils/supabase/info.tsx`

### Erro 5: "Function deploy failed"

**Possíveis causas e soluções**:

1. **Limite de funções atingido** (Free tier = 2 funções):
   - Solução: Delete funções antigas no dashboard
   - Ou: Upgrade para plano Pro

2. **Erro de sintaxe no código**:
   - Verifique o arquivo `/supabase/functions/lidia-api/index.ts`
   - Certifique-se de que não há erros de TypeScript

3. **Falta de permissões**:
   - Faça login novamente: `npx supabase login`
   - Verifique se tem acesso ao projeto

### Erro 6: Ainda recebe "Failed to fetch" após deploy

**Diagnóstico**:

1. Verifique se a função está ativa no dashboard:
   - https://supabase.com/dashboard/project/ualnpxcicdsziqnftmek/functions

2. Veja os logs da função:
   - https://supabase.com/dashboard/project/ualnpxcicdsziqnftmek/logs/edge-functions

3. Teste direto no navegador:
   - Abra: https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api
   - Deve retornar JSON

4. Verifique CORS:
   - Se retornar JSON no curl mas falhar no navegador, pode ser CORS
   - Solução: Adicionar headers CORS na função (já está implementado)

---

## 📁 Estrutura da Edge Function

A função deve estar em:
```
/supabase/functions/lidia-api/index.ts
```

Com os seguintes endpoints:
- `GET /` - Info da API
- `GET /health` - Health check
- `POST /professor-signup` - Criar professor
- `POST /signup` - Criar aluno
- `POST /login` - Login
- `POST /init-professor` - Inicializar professor padrão

---

## 🔐 Credenciais Padrão

Após o deploy, você pode fazer login com:

### Professor Padrão
- **Username**: `admin`
- **Password**: `admin123`
- **Email**: `admin@projetolidia.com`

### Criar Novo Professor
1. Clique em "Criar Conta de Professor"
2. Use email terminando com `@projetolidia.com`
3. Exemplo: `joao.silva@projetolidia.com`

### Criar Aluno
1. Clique em "Criar Conta de Aluno"  
2. Use matrícula de teste
3. Exemplo: `202401234`

---

## 📊 Verificação Final

Execute este checklist:

- [ ] `npx supabase login` executado com sucesso
- [ ] `npx supabase link` conectado ao projeto
- [ ] `npx supabase functions deploy lidia-api` concluído sem erros
- [ ] `curl` para endpoint raiz retorna JSON
- [ ] `curl` para `/health` retorna status ok
- [ ] Login no navegador com admin/admin123 funciona
- [ ] Console do navegador não mostra mais "Failed to fetch"

---

## 🆘 AINDA NÃO FUNCIONOU?

### Opção 1: Deploy Manual via Dashboard

1. Acesse: https://supabase.com/dashboard/project/ualnpxcicdsziqnftmek/functions
2. Clique em "New Function"
3. Nome: `lidia-api`
4. Cole o conteúdo de `/supabase/functions/lidia-api/index.ts`
5. Clique em "Deploy"

### Opção 2: Verificar Configuração

Execute este script de diagnóstico:

```bash
# Verificar se arquivo de configuração existe
cat utils/supabase/info.tsx

# Verificar se Supabase CLI está instalado
npx supabase --version

# Verificar status do projeto
npx supabase projects list

# Verificar funções deployadas
npx supabase functions list
```

### Opção 3: Redeploy Completo

```bash
# 1. Deletar função antiga (se existir)
npx supabase functions delete lidia-api

# 2. Esperar alguns segundos
sleep 5

# 3. Fazer deploy novamente
npx supabase functions deploy lidia-api

# 4. Testar
curl https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api
```

---

## 🎯 Resultado Esperado

Após seguir estes passos, você deve conseguir:

✅ Fazer login com admin/admin123  
✅ Criar nova conta de professor  
✅ Criar nova conta de aluno  
✅ Navegar no dashboard  
✅ **NÃO** ver mais erros "Failed to fetch"

---

## 📞 Logs para Debugging

Se ainda houver problemas, colete estes logs:

### 1. Console do Navegador (F12)
```javascript
// Deve mostrar:
Attempting login... {username: "admin", type: "professor"}
Response received: 200 OK
Login response: {ok: true, status: 200, success: true}
```

### 2. Logs do Supabase
- Acesse: https://supabase.com/dashboard/project/ualnpxcicdsziqnftmek/logs/edge-functions
- Filtre por: `lidia-api`
- Veja se há erros

### 3. Network Tab (F12 → Network)
- Procure por request para `/lidia-api/login`
- Status deve ser `200 OK`
- Response deve ser JSON com `success: true`

---

## ✅ Sucesso!

Se tudo funcionou, você deve ver:

1. ✅ Login funciona
2. ✅ Criação de conta funciona
3. ✅ Dashboard carrega corretamente
4. ✅ Sem erros no console

**Próximos passos**: Use o sistema normalmente e execute os testes em `/test-professor-auth.sh`

---

**Projeto LIDIA** - Sistema de Apoio a Alunos com TEA  
Deploy e troubleshooting: 28/11/2025 💚
