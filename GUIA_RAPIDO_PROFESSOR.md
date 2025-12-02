# 🎓 Guia Rápido - Autenticação de Professor

## ✅ O que foi corrigido

**Problema anterior**: Login de professor sempre falha mesmo com credenciais corretas

**Solução**: Corrigido o endpoint de login para usar o email real do professor cadastrado, não um formato padrão

---

## 🚀 Como Fazer Deploy

### 1. Verificar configuração do Supabase
```bash
# Verifique se o arquivo tem as credenciais corretas
cat utils/supabase/info.tsx
```

Deve ter:
```typescript
export const projectId = "ualnpxcicdsziqnftmek";
export const publicAnonKey = "SUA_ANON_KEY_AQUI";
```

### 2. Fazer deploy da Edge Function corrigida
```bash
# Login no Supabase
npx supabase login

# Linkar projeto
npx supabase link --project-ref ualnpxcicdsziqnftmek

# Deploy da função
npx supabase functions deploy lidia-api

# Verificar se funcionou
curl https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api
```

---

## 🧪 Testar o Sistema

### Opção 1: Script Automatizado (Recomendado)

```bash
# Tornar o script executável
chmod +x test-professor-auth.sh

# Executar testes
./test-professor-auth.sh
```

Este script testa:
- ✅ Health check da API
- ✅ Inicialização do admin padrão
- ✅ Login com admin
- ✅ Criação de novo professor
- ✅ Login com novo professor
- ✅ Validação de duplicação

### Opção 2: Teste Manual no Navegador

#### Criar Conta de Professor:

1. Abra a aplicação no navegador
2. Selecione **"Professor"** no tipo de login
3. Clique em **"Criar Conta de Professor"**
4. Preencha:
   - **Nome Completo**: `João Silva`
   - **Email**: `joao.silva@projetolidia.com` (DEVE terminar com @projetolidia.com)
   - **Senha**: `senha123` (mínimo 6 caracteres)
   - **Confirmar Senha**: `senha123`
   - **Especialização**: `Psicologia` (opcional)
5. Clique em **"Criar Conta de Professor"**

#### Fazer Login:

1. Na tela de login, selecione **"Professor"**
2. Digite o **username** (parte antes do @):
   - Se o email foi `joao.silva@projetolidia.com`, o username é `joao.silva`
3. Digite a senha
4. Clique em **"Entrar no Sistema"**

---

## 👨‍🏫 Credenciais do Professor Padrão

Para testes rápidos, use o professor admin pré-configurado:

- **Username**: `admin`
- **Senha**: `admin123`

Este usuário é criado automaticamente ao iniciar a aplicação.

---

## 📝 Regras de Cadastro

### Email Institucional
- ✅ DEVE terminar com `@projetolidia.com`
- ❌ Outros domínios NÃO são aceitos
- Exemplo válido: `maria.santos@projetolidia.com`
- Exemplo inválido: `maria@gmail.com`

### Username
- Extraído automaticamente do email (parte antes do @)
- Exemplo: email `joao.silva@projetolidia.com` → username `joao.silva`

### Senha
- Mínimo 6 caracteres
- Deve ser igual em "Senha" e "Confirmar Senha"

### Nome
- Obrigatório
- Nome completo do professor

### Especialização
- Opcional
- Exemplos: "Psicologia", "Pedagogia", "Educação Especial"

---

## ⚠️ Mensagens de Erro e Soluções

### "Apenas emails @projetolidia.com são permitidos"
**Causa**: Email não termina com @projetolidia.com  
**Solução**: Use um email com o domínio correto

### "Este usuário já está cadastrado"
**Causa**: O username já existe no sistema  
**Solução**: Use outro email ou faça login com as credenciais existentes

### "Este email já está cadastrado"
**Causa**: O email já está cadastrado no Supabase Auth  
**Solução**: Faça login com as credenciais existentes

### "As senhas não coincidem"
**Causa**: "Senha" e "Confirmar Senha" são diferentes  
**Solução**: Digite a mesma senha nos dois campos

### "A senha deve ter pelo menos 6 caracteres"
**Causa**: Senha muito curta  
**Solução**: Use uma senha com 6 ou mais caracteres

### "Tempo de espera esgotado"
**Causa**: Problemas de conexão ou Edge Function não deployada  
**Solução**: 
1. Verifique sua conexão com internet
2. Verifique se a Edge Function foi deployada
3. Tente novamente

### "Sistema não configurado corretamente"
**Causa**: Credenciais do Supabase não configuradas  
**Solução**: Configure `utils/supabase/info.tsx` com as credenciais corretas

### "Credenciais inválidas"
**Causa**: Username ou senha incorretos  
**Solução**: 
1. Verifique se está usando o **username** (não o email completo)
2. Verifique se a senha está correta
3. Tente usar o admin padrão: `admin` / `admin123`

---

## 🔧 Troubleshooting

### O login ainda falha após criar conta

**Diagnóstico**:
```bash
# 1. Verifique se a Edge Function foi deployada
curl https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api

# 2. Teste o endpoint de health check
curl https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api/health

# 3. Execute os testes automatizados
./test-professor-auth.sh
```

**Soluções**:
1. Refazer o deploy da Edge Function:
   ```bash
   npx supabase functions deploy lidia-api --no-verify-jwt
   ```

2. Verificar logs no Supabase Dashboard:
   - Abra: https://supabase.com/dashboard/project/ualnpxcicdsziqnftmek/logs/edge-functions
   - Procure por erros na função `lidia-api`

3. Limpar cache do navegador:
   - Pressione `Ctrl+Shift+Delete` (ou `Cmd+Shift+Delete` no Mac)
   - Limpe "Cookies e dados de site"
   - Recarregue a página

### "Failed to fetch" ou erro de CORS

**Causa**: Edge Function não está respondendo ou problema de CORS

**Soluções**:
1. Verifique se a função está deployada
2. Verifique os logs no Supabase Dashboard
3. Refaça o deploy com `--no-verify-jwt`:
   ```bash
   npx supabase functions deploy lidia-api --no-verify-jwt
   ```

### Conta criada mas não consigo fazer login

**Causa**: Inconsistência entre email cadastrado e formato de login

**Verificação**:
1. Vá ao Supabase Dashboard
2. Abra "Authentication" → "Users"
3. Verifique qual email foi criado
4. Use o username (parte antes do @) para fazer login

**Exemplo**:
- Email cadastrado: `joao.silva@projetolidia.com`
- Username para login: `joao.silva`

---

## 📊 Estrutura de Dados

### Perfil do Professor (salvo no KV Store)

```json
{
  "id": "uuid-do-supabase",
  "name": "João Silva",
  "username": "joao.silva",
  "email": "joao.silva@projetolidia.com",
  "specialization": "Psicologia",
  "type": "professor",
  "createdAt": "2025-11-28T10:30:00.000Z"
}
```

### Chaves no KV Store

- `professor_profile:joao.silva` - Busca por username
- `professor_profile_by_id:uuid-do-supabase` - Busca por ID

---

## 🔐 Segurança

### Senhas
- ✅ Hasheadas automaticamente pelo Supabase Auth
- ✅ Nunca armazenadas em texto plano
- ✅ Mínimo 6 caracteres obrigatório

### Emails
- ✅ Apenas domínio @projetolidia.com aceito
- ✅ Validação no frontend e backend
- ✅ Verificação de duplicação

### Access Tokens
- ✅ Gerados pelo Supabase Auth
- ✅ Armazenados no localStorage do navegador
- ✅ Enviados no header Authorization

---

## 📞 Suporte

Se os problemas persistirem:

1. **Verifique os logs**:
   - Console do navegador (F12)
   - Logs da Edge Function no Supabase Dashboard

2. **Teste com curl**:
   ```bash
   # Criar professor
   curl -X POST https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api/professor-signup \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer YOUR_ANON_KEY" \
     -d '{
       "name": "Teste",
       "email": "teste@projetolidia.com",
       "username": "teste",
       "password": "senha123"
     }'
   
   # Fazer login
   curl -X POST https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api/login \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer YOUR_ANON_KEY" \
     -d '{
       "username": "teste",
       "password": "senha123",
       "type": "professor"
     }'
   ```

3. **Consulte a documentação completa**:
   - Leia `/AUTENTICACAO_PROFESSOR.md` para detalhes técnicos

---

## ✨ Recursos

- ✅ Criação de conta com validação completa
- ✅ Login funcional com email real
- ✅ Auto-login após criar conta
- ✅ Mensagens de erro específicas
- ✅ Professor admin pré-configurado
- ✅ Interface responsiva (mobile + desktop)
- ✅ Timeout e tratamento de erros de rede
- ✅ Validação de domínio de email
- ✅ Validação de duplicação

---

## 🎯 Próximos Passos

Após login bem-sucedido, o professor terá acesso a:

- 📊 Dashboard com estatísticas
- 👥 Gestão de alunos
- 📝 Análise de situações
- 💡 Orientações de IA
- 📚 Recursos educacionais
- 📈 Relatórios detalhados
- 🔔 Sistema de notificações

---

## 📖 Documentação Adicional

- `/AUTENTICACAO_PROFESSOR.md` - Documentação técnica completa
- `/test-professor-auth.sh` - Script de testes automatizados
- `/LEIA-ME-PRIMEIRO.md` - Visão geral do projeto
- `/SOLUCAO_FINAL_403.md` - Histórico de correções

---

**Projeto LIDIA** - Sistema de Apoio a Alunos com TEA  
Desenvolvido com foco em inclusão e educação especializada 💚
