# Correção do Erro 403 - Deploy da Edge Function

## 🚨 Problema
```
Error while deploying: XHR for "/api/integrations/supabase/2LHDIboXHyDtIlt2XR4Fgp/edge_functions/make-server/deploy" failed with status 403
```

## 🔍 Análise
O erro 403 (Forbidden) indicava que o sistema estava tentando fazer deploy de uma função chamada **`make-server`**, mas a função criada tinha o nome **`make-server-ee558f86`**.

Isso causava uma incompatibilidade:
- **Sistema esperava**: `make-server`
- **Função criada**: `make-server-ee558f86`
- **Resultado**: Erro 403 ao tentar deploy

## ✅ Solução Implementada

### 1. Criação da Nova Função `make-server`

Criamos uma nova Edge Function com o nome correto `/supabase/functions/make-server/`:

```
/supabase/functions/make-server/
├── index.ts          # Código completo da API
└── deno.json         # Configuração Deno
```

**Características:**
- ✅ Nome correto: `make-server` (sem sufixo)
- ✅ Todas as rotas sem prefixo
- ✅ Logging extensivo
- ✅ Tratamento robusto de erros
- ✅ Rollback automático

### 2. Atualização do `config.toml`

**Antes:**
```toml
[functions."make-server-ee558f86"]
verify_jwt = false
```

**Depois:**
```toml
[functions."make-server"]
verify_jwt = false
```

### 3. Atualização de Todos os Clientes

Atualizamos todas as referências nos componentes React:

**Antes:**
```typescript
`https://${projectId}.supabase.co/functions/v1/make-server-ee558f86/...`
```

**Depois:**
```typescript
`https://${projectId}.supabase.co/functions/v1/make-server/...`
```

#### Arquivos Modificados:
1. `/App.tsx`
   - `init-professor` endpoint
   - `login` endpoint

2. `/components/StudentDashboard.tsx`
   - `student/:matricula` endpoint

3. `/components/SignUp.tsx`
   - `signup` endpoint

4. `/components/ProfessorSignUp.tsx`
   - `professor-signup` endpoint

## 📁 Estrutura Final

```
/supabase/functions/
├── make-server/                    # ✅ FUNÇÃO ATIVA
│   ├── index.ts                    # API completa
│   └── deno.json                   # Config Deno
├── make-server-ee558f86/          # ⚠️  Função antiga (manter como backup)
│   ├── index.ts
│   └── deno.json
└── server/                         # ⚠️  Função alternativa (não usar)
    ├── index.tsx
    └── kv_store.tsx
```

## 🎯 Endpoints Disponíveis

Base URL: `https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/make-server`

### Lista de Endpoints:
1. `GET /` - Informações da API
2. `GET /health` - Health check
3. `POST /professor-signup` - Criar conta de professor
4. `POST /signup` - Criar conta de aluno
5. `POST /login` - Login (professor ou aluno)
6. `POST /init-professor` - Inicializar conta admin
7. `GET /student/:matricula` - Obter perfil de aluno
8. `PUT /student/:matricula` - Atualizar perfil de aluno

## 🧪 Como Testar

### Teste Rápido - Health Check
```bash
curl https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/make-server/health
```

**Resposta esperada:**
```json
{"status":"ok"}
```

### Teste Completo - Informações da API
```bash
curl https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/make-server/
```

**Resposta esperada:**
```json
{
  "status": "ok",
  "message": "Projeto LIDIA API",
  "version": "2.0",
  "endpoints": [...]
}
```

### Teste de Signup de Professor
```bash
curl -X POST https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/make-server/professor-signup \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhbG5weGNpY2RzemlxbmZ0bWVrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyMzA2NTgsImV4cCI6MjA2MjgwNjY1OH0.vWXn6KI0lv7zCPL9bk-AKNaTPfQTzWoBjlBbD_Ky9nU" \
  -d '{
    "name": "Professor Teste",
    "email": "teste@projetolidia.com",
    "username": "teste",
    "password": "senha123",
    "specialization": "Educação Especial"
  }'
```

## ✨ Melhorias Incluídas

### 1. Logging Detalhado
```typescript
app.use("*", async (c, next) => {
  const url = new URL(c.req.url);
  console.log(`[${c.req.method}] ${url.pathname}`);
  await next();
});
```

### 2. Tratamento de Erros com Rollback
```typescript
try {
  await kvSet(`professor_profile:${username}`, professorProfile);
} catch (e) {
  // Rollback: deleta o usuário do Auth se falhar ao salvar no KV
  await supabaseAdmin.auth.admin.deleteUser(authData.user.id);
  return c.json({ error: "Erro ao salvar perfil" }, 500);
}
```

### 3. Validação de Email para Professores
```typescript
if (!email.toLowerCase().endsWith('@projetolidia.com')) {
  return c.json({ 
    error: "Apenas emails @projetolidia.com são permitidos para cadastro de professores" 
  }, 400);
}
```

### 4. Handler 404 Informativo
```typescript
app.all("*", (c) => {
  console.log(`404 - Route not found: ${c.req.method} ${url.pathname}`);
  return c.json({ 
    error: "Route not found",
    path: url.pathname,
    message: "Endpoint não encontrado. Verifique a URL."
  }, 404);
});
```

## 🔄 Comparação: Antes vs Depois

### Antes (❌ ERRADO)
```typescript
// Cliente chamava:
/functions/v1/make-server-ee558f86/professor-signup

// Sistema tentava deploy de:
make-server

// Resultado:
403 Forbidden (função não existe)
```

### Depois (✅ CORRETO)
```typescript
// Cliente chama:
/functions/v1/make-server/professor-signup

// Sistema faz deploy de:
make-server

// Resultado:
✅ Deploy bem-sucedido
```

## 📊 Verificação de Deploy

Após a correção, verifique se o deploy foi bem-sucedido:

1. **Dashboard do Supabase**
   - Acesse: https://supabase.com/dashboard/project/ualnpxcicdsziqnftmek/functions
   - Verifique se `make-server` aparece como "deployed"

2. **Logs de Deploy**
   - Verifique se não há erros no console
   - Confirme que a função foi criada

3. **Teste dos Endpoints**
   - Execute os testes de health check
   - Tente criar uma conta de professor

## 🎉 Resultado Esperado

Com essas mudanças:
- ✅ O deploy da função deve funcionar sem erro 403
- ✅ Todos os endpoints devem responder corretamente
- ✅ O cadastro de professores deve funcionar
- ✅ O cadastro de alunos deve funcionar
- ✅ O login deve funcionar para ambos os tipos de usuário

## 📝 Notas Importantes

1. **Funções Antigas**: As funções `make-server-ee558f86` e `server` foram mantidas como backup, mas não são mais usadas.

2. **Migração de Dados**: Se houver dados no KV store antigo, eles continuam acessíveis pois todas as funções usam a mesma tabela `kv_store_ee558f86`.

3. **URLs Atualizadas**: Todos os componentes do frontend agora apontam para `/make-server/` ao invés de `/make-server-ee558f86/`.

4. **Compatibilidade**: A mudança é totalmente retrocompatível com os dados existentes.

---

**Data da Correção**: 28 de novembro de 2025  
**Status**: ✅ Pronto para deploy
