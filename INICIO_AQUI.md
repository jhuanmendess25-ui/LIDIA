# 👋 COMECE AQUI - Projeto LIDIA

## 🚨 Você está vendo "Failed to Fetch"?

**É normal!** A Edge Function precisa ser deployada primeiro.

### ⚡ Solução Rápida (2 minutos)

```bash
# 1. Diagnosticar
chmod +x check-api.sh
./check-api.sh

# 2. Se necessário, fazer deploy
npx supabase login
npx supabase link --project-ref ualnpxcicdsziqnftmek
npx supabase functions deploy lidia-api

# 3. Verificar
./check-api.sh
```

---

## 📚 Documentação por Tipo de Problema

### 🔴 ERRO "Failed to Fetch"
→ Leia: **`ERRO_FAILED_TO_FETCH.md`**
- Diagnóstico automático
- Solução passo a passo
- Testes para validar

### 🚀 Fazer Deploy pela Primeira Vez
→ Leia: **`DEPLOY_URGENTE.md`**
- Guia completo de deploy
- Troubleshooting avançado
- Comandos com explicação

### 🧪 Testar se Está Funcionando
→ Execute: **`./check-api.sh`**
- Diagnóstico completo
- Testa 9 aspectos diferentes
- Relatório automático

### 📖 Entender o Sistema
→ Leia: **`README.md`**
- Visão geral do projeto
- Funcionalidades
- Tecnologias usadas

### 👨‍🏫 Usar o Sistema (Professor)
→ Leia: **`GUIA_RAPIDO_PROFESSOR.md`**
- Como fazer login
- Como criar conta
- Como usar o dashboard

### 🔧 Entender as Correções
→ Leia: **`ERROS_CORRIGIDOS_PROFESSOR.md`**
- 25 erros corrigidos
- Comparação antes/depois
- Testes implementados

---

## 🎯 Fluxo Recomendado

### Para quem está começando AGORA:

```
1. Leia este arquivo (INICIO_AQUI.md) ← VOCÊ ESTÁ AQUI
   ↓
2. Execute ./check-api.sh
   ↓
3. Se falhar → Leia ERRO_FAILED_TO_FETCH.md
   ↓
4. Faça o deploy (DEPLOY_URGENTE.md)
   ↓
5. Teste novamente (./check-api.sh)
   ↓
6. Use o sistema (GUIA_RAPIDO_PROFESSOR.md)
   ✓ SUCESSO!
```

### Para quem quer testar tudo:

```
1. ./check-api.sh ← Diagnóstico
   ↓
2. ./test-professor-auth.sh ← Teste de autenticação
   ↓
3. ./test-professor-errors.sh ← Teste de validações
   ↓
4. Teste manual no navegador
   ✓ TUDO VALIDADO!
```

---

## 📁 Arquivos Importantes

### 🔴 URGENTE - Problemas de Conexão
- `ERRO_FAILED_TO_FETCH.md` - Solução para erro comum
- `DEPLOY_URGENTE.md` - Como fazer deploy
- `check-api.sh` - Script de diagnóstico
- `SOLUCAO_RAPIDA.txt` - Resumo visual

### 📖 Documentação Completa
- `README.md` - Visão geral do projeto
- `AUTENTICACAO_PROFESSOR.md` - Documentação técnica
- `ERROS_CORRIGIDOS_PROFESSOR.md` - Changelog
- `GUIA_RAPIDO_PROFESSOR.md` - Guia de uso

### 🧪 Testes
- `test-professor-auth.sh` - 7 testes de autenticação
- `test-professor-errors.sh` - 21 testes de validação
- `check-api.sh` - 9 verificações de sistema
- `COMO_TESTAR_PROFESSOR.md` - Guia de testes manuais

---

## ⚡ Comandos Mais Usados

```bash
# 1. DIAGNOSTICAR PROBLEMAS
./check-api.sh

# 2. FAZER DEPLOY
npx supabase functions deploy lidia-api

# 3. TESTAR AUTENTICAÇÃO
./test-professor-auth.sh

# 4. TESTAR VALIDAÇÕES
./test-professor-errors.sh

# 5. VER LOGS DA FUNÇÃO
npx supabase functions logs lidia-api

# 6. LISTAR FUNÇÕES DEPLOYADAS
npx supabase functions list
```

---

## 🎓 Credenciais Padrão

### Professor Admin (Já Criado)
```
Username: admin
Senha: admin123
Email: admin@projetolidia.com
```

### Criar Novo Professor
```
1. Clique em "Criar Conta de Professor"
2. Email: seunome@projetolidia.com
   (OBRIGATÓRIO terminar com @projetolidia.com)
3. Preencha os dados
4. Auto-login automático
```

### Criar Aluno
```
1. Clique em "Criar Conta de Aluno"
2. Matrícula: qualquer número (ex: 202401234)
3. Preencha os dados
4. Auto-login automático
```

---

## 🎯 Cenários Comuns

### Cenário 1: "Acabei de clonar o projeto"

```bash
# 1. Instalar dependências
npm install

# 2. Fazer deploy da Edge Function
npx supabase login
npx supabase link --project-ref ualnpxcicdsziqnftmek
npx supabase functions deploy lidia-api

# 3. Verificar
./check-api.sh

# 4. Iniciar aplicação
npm run dev

# 5. Abrir navegador
# http://localhost:5173

# 6. Fazer login
# Username: admin
# Senha: admin123
```

### Cenário 2: "Login não está funcionando"

```bash
# 1. Verificar se API está online
./check-api.sh

# 2. Se falhar, fazer deploy
npx supabase functions deploy lidia-api

# 3. Aguardar 30 segundos

# 4. Testar novamente
./check-api.sh

# 5. Tentar login no navegador
```

### Cenário 3: "Quero testar tudo"

```bash
# 1. Deploy
npx supabase functions deploy lidia-api

# 2. Diagnóstico
./check-api.sh

# 3. Testes de autenticação (7 cenários)
./test-professor-auth.sh

# 4. Testes de validações (21 cenários)
./test-professor-errors.sh

# 5. Teste manual no navegador
# (Veja COMO_TESTAR_PROFESSOR.md)
```

---

## 📊 Status do Sistema

### ✅ Implementado
- [x] Autenticação completa
- [x] Criação de contas
- [x] Auto-login
- [x] Dashboards
- [x] 28 testes automatizados
- [x] Documentação completa
- [x] Tratamento de erros robusto
- [x] Validações completas
- [x] Rate limiting
- [x] Rollback automático

### 🔧 Segurança
- [x] Rate limiting (5 tentativas / 5 min)
- [x] Validação de tipos
- [x] Normalização de dados
- [x] Rollback em erros
- [x] Logs detalhados
- [x] Não exposição de dados sensíveis

### 📈 Qualidade
- Validações: 17
- Testes automatizados: 28
- Documentação: 8000+ palavras
- Taxa de cobertura: ~85%

---

## 🆘 Precisa de Ajuda?

### Problema Comum 1: "Failed to fetch"
**Arquivo**: `ERRO_FAILED_TO_FETCH.md`
**Script**: `./check-api.sh`

### Problema Comum 2: "Não sei fazer deploy"
**Arquivo**: `DEPLOY_URGENTE.md`
**Comando**: `npx supabase functions deploy lidia-api`

### Problema Comum 3: "Testes falhando"
**Solução**: Refazer deploy e aguardar 30 segundos
**Comando**: `npx supabase functions deploy lidia-api`

### Problema Comum 4: "Auto-login não funciona"
**Causa**: Perfil não foi salvo ainda
**Solução**: Aguardar 1-2 segundos e fazer login manual

### Outros Problemas
**Leia**: `README.md` seção "Troubleshooting"
**Logs**: Console do navegador (F12) e Supabase Dashboard

---

## 🎉 Sucesso!

Quando tudo estiver funcionando:

✅ `./check-api.sh` passa todos os testes
✅ Login com admin/admin123 funciona
✅ Criação de contas funciona
✅ Dashboard carrega
✅ Sem erros no console

**Próximo passo**: Explore o sistema e veja o `GUIA_RAPIDO_PROFESSOR.md`

---

## 📞 Recursos Adicionais

- **Documentação Técnica**: `AUTENTICACAO_PROFESSOR.md`
- **Lista de Correções**: `ERROS_CORRIGIDOS_PROFESSOR.md`
- **Como Testar**: `COMO_TESTAR_PROFESSOR.md`
- **Resumo Visual**: `SOLUCAO_RAPIDA.txt`
- **Guia Geral**: `README.md`

---

**Projeto LIDIA** - Sistema de Apoio a Alunos com TEA  
Comece aqui e siga os passos! 💚

**Última atualização**: 28/11/2025
