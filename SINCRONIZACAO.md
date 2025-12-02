# Sistema de Sincronização Global - Projeto LIDIA

## Visão Geral

O Projeto LIDIA implementa um sistema robusto de sincronização de dados usando **React Context API**, garantindo que todas as alterações nos dados dos alunos sejam propagadas instantaneamente em todo o sistema, tanto na interface do professor quanto na interface dos alunos.

## Arquitetura de Sincronização

### 1. Context API Central (`/contexts/DataContext.tsx`)

O DataContext é o núcleo do sistema de gerenciamento de estado global. Ele mantém:

- **students**: Array com todos os alunos cadastrados
- **emotionRecords**: Registros de emoções enviados pelos alunos
- **communicationRecords**: Mensagens PECS enviadas pelos alunos
- **studentOrientations**: Orientações de IA geradas para cada aluno

### 2. Sincronização Automática ao Editar Alunos

Quando um aluno é editado através do `EditStudentModal`, a função `updateStudent` executa:

#### Passo 1: Atualização do Registro do Aluno
```typescript
const updatedStudent = { ...student, ...updates };
```

#### Passo 2: Atualização do Avatar
Se o nome mudar, a foto é atualizada com a primeira letra do novo nome:
```typescript
if (updates.name && updates.name !== student.name) {
  updatedStudent.photo = updates.name.charAt(0).toUpperCase();
}
```

#### Passo 3: Sincronização Global de Registros
Quando o nome muda, TODOS os registros relacionados são atualizados:

**a) Registros de Emoções**
```typescript
setEmotionRecords(prevRecords => prevRecords.map(record => 
  record.studentId === student.enrollmentId 
    ? { ...record, studentName: updates.name! } 
    : record
));
```

**b) Registros de Comunicação**
```typescript
setCommunicationRecords(prevRecords => prevRecords.map(record => 
  record.studentId === student.enrollmentId 
    ? { ...record, studentName: updates.name! } 
    : record
));
```

**c) Orientações**
```typescript
setStudentOrientations(prevOrientations => prevOrientations.map(orientation => 
  orientation.studentId === student.id 
    ? { ...orientation, studentName: updates.name! } 
    : orientation
));
```

## Componentes que Se Beneficiam da Sincronização

### 1. Interface do Aluno (`StudentDashboard.tsx`)

```typescript
const student = students.find(s => s.enrollmentId === userId);
```

**Atualização Automática:**
- ✅ Nome do aluno no cabeçalho
- ✅ Série e sala de aula
- ✅ Turno
- ✅ Informações de perfil

### 2. Painel de Notificações (`NotificationsPanel.tsx`)

**Atualização Automática:**
- ✅ Nome do aluno em registros de emoções
- ✅ Nome do aluno em comunicações PECS
- ✅ Histórico completo de interações

### 3. Nova Análise (`NewAnalysis.tsx`)

```typescript
const selectedStudent = students.find(s => s.id.toString() === formData.studentId);
```

**Card Informativo com Atualização Automática:**
- ✅ Nome
- ✅ Condição e nível (TEA/TOD)
- ✅ Idade
- ✅ Tipo de comunicação
- ✅ Sensibilidades
- ✅ Pontos fortes

### 4. Solicitar Orientação (`RequestOrientation.tsx`)

```typescript
const selectedStudent = students.find(s => s.id.toString() === formData.studentId);
```

**Card Informativo com Atualização Automática:**
- ✅ Todas as informações do perfil do aluno
- ✅ Dados para geração de orientações personalizadas

### 5. Orientações (`Orientations.tsx`)

**Atualização Automática:**
- ✅ Nome do aluno nas orientações geradas
- ✅ Histórico de orientações
- ✅ Recomendações personalizadas

### 6. Gerenciamento de Alunos (`StudentsManagement.tsx`)

**Atualização Automática:**
- ✅ Lista completa de alunos
- ✅ Cards com informações atualizadas
- ✅ Filtros e busca

### 7. Relatórios (`Reports.tsx`)

**Atualização Automática:**
- ✅ Nome dos alunos nos gráficos
- ✅ Estatísticas atualizadas
- ✅ Análises de tendências

## Fluxo de Atualização

```
Professor edita aluno
    ↓
EditStudentModal.handleSubmit()
    ↓
DataContext.updateStudent()
    ↓
┌─────────────────────────────────────────┐
│ Atualização Síncrona em Paralelo:      │
├─────────────────────────────────────────┤
│ 1. Array students                       │
│ 2. emotionRecords (se nome mudou)       │
│ 3. communicationRecords (se nome mudou) │
│ 4. studentOrientations (se nome mudou)  │
└─────────────────────────────────────────┘
    ↓
React re-renderiza TODOS os componentes
que usam useData()
    ↓
┌─────────────────────────────────────────┐
│ Interfaces Atualizadas Automaticamente: │
├─────────────────────────────────────────┤
│ ✓ Dashboard do Professor                │
│ ✓ Dashboard do Aluno                    │
│ ✓ Painel de Notificações                │
│ ✓ Cards Informativos                    │
│ ✓ Relatórios e Gráficos                 │
│ ✓ Orientações                           │
│ ✓ Histórico de Registros                │
└─────────────────────────────────────────┘
```

## Feedback ao Usuário

Quando um aluno é editado, o sistema mostra uma notificação de sucesso usando **Sonner Toast**:

```typescript
toast.success('Aluno atualizado com sucesso!', {
  description: 'Todas as informações foram atualizadas em todo o sistema, incluindo registros de emoções, comunicações e orientações.'
});
```

## Vantagens da Arquitetura

### 1. Consistência de Dados
- ✅ Dados sempre sincronizados em toda a aplicação
- ✅ Sem discrepâncias entre diferentes telas
- ✅ Histórico mantém integridade referencial

### 2. Performance
- ✅ Atualizações em tempo real
- ✅ Re-renderização eficiente com React
- ✅ Sem necessidade de recarregar a página

### 3. Manutenibilidade
- ✅ Código centralizado no DataContext
- ✅ Fácil de adicionar novos campos
- ✅ Lógica de sincronização em um único lugar

### 4. Experiência do Usuário
- ✅ Feedback imediato após edições
- ✅ Interface sempre atualizada
- ✅ Transições suaves entre estados

## Campos Sincronizados

Quando um aluno é editado, os seguintes campos são propagados:

### Informações Básicas
- Nome completo
- Idade
- Data de nascimento
- Gênero
- Série/Ano
- Sala de aula
- Turno

### Informações da Condição
- Tipo (TEA/TOD/TEA+TOD)
- Nível/Gravidade
- Tipo de comunicação
- Sensibilidades
- Pontos fortes

### Informações do Responsável
- Nome do responsável
- Telefone
- E-mail

## Casos de Uso

### Caso 1: Professor Corrige Nome do Aluno
1. Professor acessa "Gerenciar Alunos"
2. Clica em "Editar" no card do aluno
3. Altera o nome de "João Silva" para "João Pedro Silva"
4. Salva as alterações
5. **Resultado**: 
   - Dashboard do aluno mostra novo nome
   - Notificações antigas mostram novo nome
   - Orientações geradas mostram novo nome
   - Card informativo em "Nova Análise" mostra novo nome
   - Toast de confirmação aparece

### Caso 2: Aluno Muda de Turma
1. Professor edita sala e turno do aluno
2. Salva as alterações
3. **Resultado**:
   - Dashboard do aluno mostra nova sala/turno
   - Relatórios refletem a mudança
   - Cards informativos mostram dados atualizados

### Caso 3: Atualização de Perfil Clínico
1. Professor atualiza nível do TEA ou sensibilidades
2. Salva as alterações
3. **Resultado**:
   - Orientações futuras usam dados atualizados
   - Cards informativos mostram perfil atualizado
   - Análises consideram novo perfil

## Testes Recomendados

### Teste 1: Edição de Nome
1. Login como professor
2. Editar nome de um aluno
3. Verificar atualização em:
   - Lista de alunos
   - Painel de notificações
   - Interface do aluno (fazer login como aluno)
   - Cards informativos

### Teste 2: Edição Múltipla
1. Editar vários campos de um aluno
2. Verificar se todos são atualizados
3. Confirmar que não há regressões

### Teste 3: Sincronização em Tempo Real
1. Abrir dashboard do professor
2. Abrir dashboard do aluno em outra aba
3. Editar aluno no dashboard do professor
4. Verificar atualização automática (pode requerer refresh manual devido a limitações do ambiente)

## Considerações de Segurança

- ✅ Validação de dados no formulário de edição
- ✅ Context API protegido por autenticação
- ✅ Dados armazenados apenas em memória (não persiste entre reloads)
- ⚠️ Para produção, integrar com Supabase para persistência

## Melhorias Futuras

1. **Persistência com Supabase**
   - Sincronização em tempo real entre dispositivos
   - Backup automático de dados
   - Histórico de alterações

2. **Auditoria**
   - Log de todas as edições
   - Rastreamento de quem fez cada mudança
   - Histórico de versões

3. **Validações Avançadas**
   - Prevenir duplicação de matrículas
   - Validar CPF do responsável
   - Validar formato de telefone

4. **Otimizações**
   - Debounce em atualizações massivas
   - Lazy loading de registros antigos
   - Paginação em listas grandes

## Conclusão

O sistema de sincronização global do Projeto LIDIA garante que todas as informações dos alunos estejam sempre atualizadas em todo o sistema, proporcionando uma experiência consistente e confiável para professores e alunos. A arquitetura baseada em Context API permite escalabilidade e facilita futuras integrações com backends como Supabase.
