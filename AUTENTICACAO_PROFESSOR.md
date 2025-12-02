# Sistema de Autenticação de Professores - LIDIA

## Problema Corrigido

### Descrição do Bug
Havia uma inconsistência crítica entre o **cadastro** e o **login** de professores:

1. **No cadastro** (`/professor-signup`):
   - O professor fornecia um email real (ex: `joao@projetolidia.com`)
   - Esse email era usado para criar a conta no Supabase Auth
   - O perfil era salvo no KV Store com o username e email

2. **No login** (`/login`):
   - O sistema tentava usar o formato `${username}@professor.lidia.edu.br`
   - Esse email NÃO correspondia ao email real cadastrado
   - **Resultado**: Login sempre falhava, mesmo com credenciais corretas

### Solução Implementada

Modificamos o endpoint `/login` para:

1. **Para professores**: Buscar o perfil do professor no KV Store e usar o email real
   ```typescript
   if (type === 'professor') {
     const professorProfile = await kvGet(`professor_profile:${username}`);
     if (professorProfile && professorProfile.email) {
       email = professorProfile.email; // Usa o email real
     }
   }
   ```

2. **Para alunos**: Continuar usando o formato padrão `${matricula}@lidia.edu.br`

## Fluxo de Autenticação

### 1. Cadastro de Professor

**Endpoint**: `POST /lidia-api/professor-signup`

**Requisitos**:
- Nome completo
- Email institucional terminando em `@projetolidia.com`
- Username (extraído do email antes do @)
- Senha (mínimo 6 caracteres)
- Especialização (opcional)

**Processo**:
```
1. Validar campos obrigatórios
2. Validar domínio do email (@projetolidia.com)
3. Verificar se username já existe no KV Store
4. Criar usuário no Supabase Auth com email real
5. Salvar perfil no KV Store:
   - professor_profile:{username}
   - professor_profile_by_id:{userId}
6. Retornar sucesso com userId e username
7. Auto-login automático
```

**Exemplo**:
```json
{
  "name": "João Silva",
  "email": "joao.silva@projetolidia.com",
  "username": "joao.silva",
  "password": "senha123",
  "specialization": "Psicologia"
}
```

### 2. Login de Professor

**Endpoint**: `POST /lidia-api/login`

**Requisitos**:
- Username (parte antes do @ do email)
- Senha
- Type: "professor"

**Processo**:
```
1. Receber username, password, type
2. Buscar perfil no KV Store: professor_profile:{username}
3. Extrair email real do perfil
4. Fazer login no Supabase Auth com email real
5. Retornar access token e dados do usuário
```

**Exemplo**:
```json
{
  "username": "joao.silva",
  "password": "senha123",
  "type": "professor"
}
```

### 3. Professor Padrão (Admin)

**Credenciais**: 
- Username: `admin`
- Senha: `admin123`

**Inicialização**:
- Criado automaticamente ao iniciar o app (endpoint `/init-professor`)
- Email: `admin@professor.lidia.edu.br`
- Se já existir, não recria

## Validações Implementadas

### No Frontend (ProfessorSignUp.tsx)

1. ✅ Validação de campos obrigatórios
2. ✅ Validação de domínio de email (@projetolidia.com)
3. ✅ Validação de senha (mínimo 6 caracteres)
4. ✅ Confirmação de senha
5. ✅ Timeout de 10 segundos
6. ✅ Tratamento de erros de rede
7. ✅ Mensagens de erro específicas

### No Backend (lidia-api/index.ts)

1. ✅ Validação de campos obrigatórios
2. ✅ Validação de domínio de email
3. ✅ Verificação de username duplicado
4. ✅ Verificação de email duplicado (Supabase Auth)
5. ✅ Transação atômica (se falhar salvar perfil, deleta auth user)
6. ✅ Logs detalhados para debugging

## Mensagens de Erro

### Erros de Validação
- `"Por favor, preencha todos os campos obrigatórios"`
- `"Apenas emails @projetolidia.com são permitidos para cadastro de professores"`
- `"As senhas não coincidem"`
- `"A senha deve ter pelo menos 6 caracteres"`

### Erros de Duplicação
- `"Este usuário já está cadastrado"`
- `"Este email já está cadastrado"`

### Erros de Conexão
- `"Tempo de espera esgotado. Verifique sua conexão e tente novamente."`
- `"Erro de conexão. Verifique sua internet e tente novamente."`

### Erros de Configuração
- `"Sistema não configurado corretamente. Entre em contato com o administrador."`

## Deploy da Edge Function

### Passo 1: Fazer Login no Supabase
```bash
npx supabase login
```

### Passo 2: Linkar o Projeto
```bash
npx supabase link --project-ref ualnpxcicdsziqnftmek
```

### Passo 3: Deploy da Função
```bash
npx supabase functions deploy lidia-api
```

### Passo 4: Verificar Deploy
```bash
curl https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api
```

Resposta esperada:
```json
{
  "status": "ok",
  "message": "Projeto LIDIA API - lidia-api",
  "version": "3.0",
  "endpoints": [...]
}
```

## Testando o Sistema

### Teste 1: Criar Conta de Professor
```bash
curl -X POST https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api/professor-signup \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -d '{
    "name": "Maria Santos",
    "email": "maria.santos@projetolidia.com",
    "username": "maria.santos",
    "password": "senha123",
    "specialization": "Pedagogia"
  }'
```

### Teste 2: Fazer Login
```bash
curl -X POST https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api/login \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -d '{
    "username": "maria.santos",
    "password": "senha123",
    "type": "professor"
  }'
```

### Teste 3: Login com Admin Padrão
```bash
curl -X POST https://ualnpxcicdsziqnftmek.supabase.co/functions/v1/lidia-api/login \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -d '{
    "username": "admin",
    "password": "admin123",
    "type": "professor"
  }'
```

## Estrutura de Dados

### Professor Profile (KV Store)
```typescript
{
  id: string,              // Supabase Auth user ID
  name: string,            // Nome completo
  username: string,        // Username único
  email: string,           // Email institucional real
  specialization?: string, // Especialização (opcional)
  type: 'professor',       // Tipo de usuário
  createdAt: string       // Data de criação (ISO)
}
```

### Chaves no KV Store
- `professor_profile:{username}` - Busca por username
- `professor_profile_by_id:{userId}` - Busca por ID do Supabase Auth

## Troubleshooting

### Problema: Login sempre falha
**Solução**: Verifique se a Edge Function foi deployada com a correção do login

### Problema: "Email já cadastrado"
**Solução**: Use outro email ou faça login com as credenciais existentes

### Problema: "Sistema não configurado"
**Solução**: Verifique se `/utils/supabase/info.tsx` tem `projectId` e `publicAnonKey` corretos

### Problema: Timeout ao criar conta
**Solução**: 
1. Verifique conexão com internet
2. Verifique se a Edge Function está deployada
3. Verifique logs do Supabase Dashboard

## Segurança

### Senhas
- Mínimo 6 caracteres
- Hasheadas automaticamente pelo Supabase Auth
- Nunca armazenadas em texto plano

### Emails
- Apenas domínio @projetolidia.com para professores
- Validação no frontend e backend
- Verificação de duplicação

### Access Tokens
- Gerados pelo Supabase Auth
- Armazenados no localStorage
- Enviados no header Authorization para requests autenticados

### KV Store
- Usa `SUPABASE_SERVICE_ROLE_KEY` (não exposta ao frontend)
- Acesso apenas via Edge Functions
- Transações atômicas

## Próximos Passos

1. ✅ Corrigir bug de login de professor
2. ✅ Adicionar validações de email
3. ✅ Melhorar mensagens de erro
4. ⬜ Adicionar recuperação de senha
5. ⬜ Adicionar verificação de email (opcional)
6. ⬜ Adicionar perfil de professor editável
7. ⬜ Adicionar logs de auditoria

## Suporte

Em caso de dúvidas ou problemas:
1. Verifique os logs no Supabase Dashboard
2. Verifique o console do navegador (F12)
3. Teste os endpoints usando curl
4. Consulte este documento
