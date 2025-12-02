# 🧪 Como Testar a Criação de Conta de Professor

## 🎯 Objetivo

Este guia mostra **passo a passo** como testar todas as correções implementadas na criação de conta de professor.

---

## 📋 Pré-requisitos

1. ✅ Edge Function `lidia-api` deployada
2. ✅ Arquivo `/utils/supabase/info.tsx` configurado
3. ✅ Aplicação rodando

### Verificar Configuração

```bash
# 1. Verificar se a Edge Function está ativa
curl https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api

# Resposta esperada:
# {"status":"ok","message":"Projeto LIDIA API - lidia-api","version":"3.0",...}

# 2. Verificar configuração local
cat utils/supabase/info.tsx
# Deve ter projectId e publicAnonKey válidos
```

---

## 🤖 Testes Automatizados (Recomendado)

### Executar Todos os Testes

```bash
# Tornar os scripts executáveis
chmod +x test-professor-auth.sh
chmod +x test-professor-errors.sh

# Executar teste completo de autenticação
./test-professor-auth.sh

# Executar teste completo de erros (21 cenários)
./test-professor-errors.sh
```

### O que os scripts testam:

**`test-professor-auth.sh`** (7 testes):
1. ✅ Health check da API
2. ✅ Inicialização do admin
3. ✅ Login com admin
4. ✅ Criação de novo professor
5. ✅ Login com novo professor
6. ✅ Validação de duplicação

**`test-professor-errors.sh`** (21 testes):
1. ✅ 7 testes de campos obrigatórios
2. ✅ 5 testes de validação de email
3. ✅ 1 teste de criação válida
4. ✅ 2 testes de duplicação
5. ✅ 3 testes de tipos de dados
6. ✅ 3 testes de normalização

---

## 🖥️ Testes Manuais no Navegador

### TESTE 1: Criação de Conta Válida (Cenário Positivo)

#### Passo 1: Acessar tela de cadastro
1. Abra a aplicação no navegador
2. Na tela de login, selecione **"Professor"**
3. Clique no botão **"Criar Conta de Professor"**

#### Passo 2: Preencher formulário
```
Nome Completo: João da Silva Santos
Email: joao.santos@projetolidia.com
Senha: senha123
Confirmar Senha: senha123
Especialização: Psicologia (opcional)
```

#### Passo 3: Criar conta
1. Clique em **"Criar Conta de Professor"**
2. Aguarde o processamento (indicador de loading)

#### ✅ Resultado Esperado:
- ✅ Mensagem de sucesso (via toast ou redirecionamento)
- ✅ Auto-login automático
- ✅ Redirecionamento para dashboard do professor
- ✅ Console mostra logs:
  ```
  Sending professor signup request...
  Response received: 200 OK
  Professor signup successful! UserId: xxx Username: joao.santos
  Auto-logging in...
  Attempting login...
  Login response: {ok: true, success: true}
  Login successful, setting authenticated state
  ```

---

### TESTE 2: Validação de Email Inválido

#### Testar email sem domínio @projetolidia.com
```
Nome: Maria Santos
Email: maria.santos@gmail.com  ← ERRADO
Senha: senha123
Confirmar Senha: senha123
```

#### ✅ Resultado Esperado:
```
❌ Email inválido. Use um email terminando com @projetolidia.com
```

#### Testar email sem @
```
Nome: Maria Santos
Email: mariasantos.com  ← ERRADO
Senha: senha123
Confirmar Senha: senha123
```

#### ✅ Resultado Esperado:
```
❌ Email inválido. Use um email terminando com @projetolidia.com
```

---

### TESTE 3: Validação de Campos Obrigatórios

#### Testar nome muito curto
```
Nome: Jo  ← ERRADO (2 caracteres)
Email: jo@projetolidia.com
Senha: senha123
Confirmar Senha: senha123
```

#### ✅ Resultado Esperado:
```
❌ O nome deve ter pelo menos 3 caracteres
```

#### Testar senha muito curta
```
Nome: João Silva
Email: joao@projetolidia.com
Senha: 12345  ← ERRADO (5 caracteres)
Confirmar Senha: 12345
```

#### ✅ Resultado Esperado:
```
❌ A senha deve ter pelo menos 6 caracteres válidos
```

---

### TESTE 4: Validação de Confirmação de Senha

```
Nome: João Silva
Email: joao@projetolidia.com
Senha: senha123
Confirmar Senha: senha456  ← ERRADO (diferente)
```

#### ✅ Resultado Esperado:
```
❌ As senhas não coincidem
```

---

### TESTE 5: Validação de Duplicação

#### Passo 1: Criar primeira conta
```
Nome: Pedro Oliveira
Email: pedro.oliveira@projetolidia.com
Senha: senha123
Confirmar Senha: senha123
```
✅ Conta criada com sucesso

#### Passo 2: Tentar criar novamente com mesmo email
1. Fazer logout
2. Voltar para tela de cadastro
3. Tentar criar conta com mesmo email

#### ✅ Resultado Esperado:
```
⚠️ Este usuário ou email já está cadastrado. Tente fazer login ou use outro email.
```

---

### TESTE 6: Normalização de Dados

#### Testar email com letras maiúsculas
```
Nome: Ana Clara
Email: ANA.CLARA@PROJETOLIDIA.COM  ← Maiúsculas
Senha: senha123
Confirmar Senha: senha123
```

#### ✅ Resultado Esperado:
- ✅ Conta criada com sucesso
- ✅ Email salvo em lowercase: `ana.clara@projetolidia.com`
- ✅ Username: `ana.clara`

#### Testar espaços extras
```
Nome:   José  Maria  Santos   ← Espaços extras
Email: jose.santos@projetolidia.com
Senha: senha123
Confirmar Senha: senha123
```

#### ✅ Resultado Esperado:
- ✅ Conta criada com sucesso
- ✅ Nome salvo sem espaços extras: `José Maria Santos`

---

### TESTE 7: Auto-login

#### Passo 1: Criar conta válida
```
Nome: Teste Auto Login
Email: autotest@projetolidia.com
Senha: senha123
Confirmar Senha: senha123
```

#### Passo 2: Observar comportamento

#### ✅ Resultado Esperado:
1. ✅ Mensagem de sucesso
2. ✅ Aguarda 1 segundo (delay implementado)
3. ✅ Faz login automaticamente
4. ✅ Redireciona para dashboard
5. ✅ **NÃO** volta para tela de login

---

### TESTE 8: Timeout e Erros de Rede

#### Simular timeout (impossível testar manualmente, mas está implementado)
- Sistema aguarda **15 segundos** antes de abortar
- Mensagem exibida: `⏱️ Tempo de espera esgotado (15s). Verifique sua conexão e tente novamente.`

#### Testar sem internet
1. Desconectar da internet
2. Tentar criar conta

#### ✅ Resultado Esperado:
```
🌐 Erro de conexão. Verifique se você está conectado à internet e tente novamente.
```

---

### TESTE 9: Rate Limiting

#### Tentar criar muitas contas rapidamente
1. Criar conta 1: `teste1@projetolidia.com`
2. Criar conta 2: `teste2@projetolidia.com`
3. Criar conta 3: `teste3@projetolidia.com`
4. Criar conta 4: `teste4@projetolidia.com`
5. Criar conta 5: `teste5@projetolidia.com`
6. Criar conta 6: `teste6@projetolidia.com` ← 6ª tentativa

#### ✅ Resultado Esperado (na 6ª tentativa):
```
⏳ Muitas tentativas. Aguarde alguns minutos e tente novamente.
```

**Nota**: Aguarde 5 minutos para poder criar contas novamente.

---

## 🔍 Verificação de Logs

### Console do Navegador (F12 → Console)

#### Logs durante criação de conta:
```javascript
Sending professor signup request... {name: "João Silva", email: "joao.silva@projetolidia.com", username: "joao.silva"}
Response received: 200 OK
Professor signup successful! UserId: abc-123-def Username: joao.silva
Auto-logging in...
Professor signup success callback - attempting auto-login... {username: "joao.silva"}
Attempting login... {username: "joao.silva", type: "professor"}
Login response: {ok: true, status: 200, success: true, error: undefined}
Login successful, setting authenticated state
```

#### Logs em caso de erro:
```javascript
Professor signup error: Error: Email inválido. Use um email terminando com @projetolidia.com
```

### Logs do Supabase Dashboard

1. Acesse: https://supabase.com/dashboard/project/ualnpxcicdsziqnftmek/logs/edge-functions
2. Selecione a função: `lidia-api`
3. Filtre por: `professor-signup`

#### Logs esperados:
```
[POST] /professor-signup
Professor signup endpoint hit
Received body: {name: "João Silva", email: "joao.silva@projetolidia.com", username: "joao.silva"}
Creating Supabase auth user... {email: "joao.silva@projetolidia.com", username: "joao.silva"}
Auth user created successfully: abc-123-def
Saving professor profile to KV store...
Professor profile saved successfully
Professor account created successfully: joao.silva
```

---

## 📊 Checklist de Testes

### Validações Frontend
- [ ] Nome obrigatório
- [ ] Nome mínimo 3 caracteres
- [ ] Email obrigatório
- [ ] Email formato válido
- [ ] Email domínio @projetolidia.com
- [ ] Senha obrigatória
- [ ] Senha mínimo 6 caracteres
- [ ] Confirmação de senha
- [ ] Senhas coincidem

### Validações Backend
- [ ] Todos os campos obrigatórios
- [ ] Tipos de dados corretos
- [ ] Tamanhos mínimos
- [ ] Email formato válido (regex)
- [ ] Email domínio correto
- [ ] Username não duplicado
- [ ] Email não duplicado

### Normalização
- [ ] Email em lowercase
- [ ] Username em lowercase
- [ ] Nome sem espaços extras
- [ ] Especialização sem espaços extras

### Segurança
- [ ] Rate limiting funciona
- [ ] Rollback em caso de erro
- [ ] Mensagens de erro não expõem detalhes internos

### Funcionalidades
- [ ] Criação de conta bem-sucedida
- [ ] Auto-login funciona
- [ ] Redirecionamento para dashboard
- [ ] Logout funciona
- [ ] Login manual funciona

### Tratamento de Erros
- [ ] Mensagens específicas para cada erro
- [ ] Ícones nas mensagens
- [ ] Timeout funciona
- [ ] Erros de rede tratados
- [ ] Duplicação detectada

---

## 🎓 Casos de Uso Reais

### Cenário 1: Professor novo se cadastrando

**História**: Professor João é novo na escola e precisa criar sua conta.

**Passos**:
1. Acessa sistema
2. Clica em "Criar Conta de Professor"
3. Preenche:
   - Nome: `João Pedro Santos`
   - Email: `joao.pedro@projetolidia.com`
   - Senha: `senhaSegura123`
   - Especialização: `Educação Especial`
4. Clica em "Criar Conta"
5. É automaticamente logado
6. Vê dashboard e pode começar a usar

✅ **Resultado**: Conta criada, logado automaticamente, pronto para usar!

---

### Cenário 2: Professor esquece de confirmar senha

**História**: Professora Maria está com pressa e esquece de confirmar a senha.

**Passos**:
1. Preenche nome e email
2. Preenche senha: `senha123`
3. Esquece de preencher "Confirmar Senha"
4. Clica em "Criar Conta"

✅ **Resultado**: Sistema mostra: `❌ Por favor, confirme a senha`

---

### Cenário 3: Professor tenta usar email pessoal

**História**: Professor Carlos tenta usar seu email do Gmail.

**Passos**:
1. Preenche:
   - Nome: `Carlos Eduardo`
   - Email: `carlos@gmail.com`
   - Senha: `senha123`
2. Clica em "Criar Conta"

✅ **Resultado**: Sistema mostra: `❌ Email inválido. Use um email terminando com @projetolidia.com`

**Solução**: Carlos corrige para `carlos.eduardo@projetolidia.com` e consegue criar conta.

---

### Cenário 4: Professor tenta criar conta duplicada

**História**: Professora Ana esqueceu que já tem conta.

**Passos**:
1. Tenta criar conta com email que já existe
2. Sistema detecta duplicação

✅ **Resultado**: Sistema mostra: `⚠️ Este usuário ou email já está cadastrado. Tente fazer login ou use outro email.`

**Solução**: Ana clica em "Voltar ao login" e faz login com credenciais existentes.

---

## 🆘 Troubleshooting

### Problema: "Sistema não configurado"
**Causa**: Supabase não configurado  
**Solução**: 
```bash
# Verificar arquivo
cat utils/supabase/info.tsx

# Deve ter:
export const projectId = "ualnpxcicdsziqnftmek";
export const publicAnonKey = "eyJ..."; // Chave válida
```

### Problema: "Tempo de espera esgotado"
**Causa**: Edge Function não responde em 15s  
**Solução**:
```bash
# 1. Verificar se função está ativa
curl https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api/health

# 2. Ver logs no dashboard
# 3. Refazer deploy
npx supabase functions deploy lidia-api
```

### Problema: Auto-login não funciona
**Causa**: Delay insuficiente ou erro no login  
**Solução**:
- Verificar console do navegador
- Se aparecer "Auto-login failed", fazer login manualmente
- Sistema deve mostrar alerta: "Conta criada com sucesso! Por favor, faça login manualmente."

### Problema: "Este email já está cadastrado" mas não lembro a senha
**Solução**: 
- (Futuro) Implementar recuperação de senha
- (Atual) Usar outro email ou contatar administrador

---

## ✅ Testes Aprovados

Se você conseguiu:
- ✅ Criar conta com dados válidos
- ✅ Ver mensagens de erro para dados inválidos
- ✅ Auto-login funciona
- ✅ Duplicação é detectada
- ✅ Normalização funciona

**🎉 TODOS OS TESTES PASSARAM!**

O sistema está funcionando corretamente e pronto para uso.

---

## 📞 Suporte

Em caso de dúvidas ou problemas:

1. **Consulte a documentação**:
   - `/ERROS_CORRIGIDOS_PROFESSOR.md` - Lista completa de correções
   - `/GUIA_RAPIDO_PROFESSOR.md` - Guia de uso rápido
   - `/AUTENTICACAO_PROFESSOR.md` - Documentação técnica

2. **Execute os testes automatizados**:
   ```bash
   ./test-professor-errors.sh
   ```

3. **Verifique os logs**:
   - Console do navegador (F12)
   - Supabase Dashboard

---

**Projeto LIDIA** - Sistema de Apoio a Alunos com TEA  
Guia de testes criado em: 28/11/2025  
Desenvolvido com foco em qualidade e usabilidade 💚
