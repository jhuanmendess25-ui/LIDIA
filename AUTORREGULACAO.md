# Sistema de Autorregulação - Projeto LIDIA

## Visão Geral

O sistema de autorregulação do Projeto LIDIA oferece **técnicas científicas personalizadas** para cada tipo de emoção que o aluno pode estar sentindo. Cada técnica foi desenvolvida com base em evidências científicas para auxiliar alunos com TEA e TOD.

## Funcionalidades Implementadas

### 1. **Personalização por Emoção**

Cada emoção tem um conjunto específico de técnicas recomendadas:

#### 😰 Ansioso
- **Respiração 4-7-8**: Técnica comprovada para reduzir ansiedade
- **Técnica 5-4-3-2-1**: Grounding sensorial para conexão com o presente
- **Abraço da Borboleta**: Estimulação bilateral calmante (EMDR)

#### 😤 Frustrado
- **Relaxamento Muscular Progressivo**: Liberação de tensão física
- **Termômetro da Raiva**: Consciência e redução da intensidade emocional
- **Pausa Estratégica**: Afastamento seguro da situação estressante

#### 😵 Sobrecarregado
- **Desligamento Sensorial**: Redução de estímulos para recuperação
- **Respiração Quadrada**: Ritmo previsível para estabilização
- **Pressão Profunda**: Estimulação tátil baseada em Temple Grandin

#### 😢 Triste
- **Auto-Compaixão**: Validação emocional gentil
- **Memória Segura**: Visualização de momentos positivos
- **Movimento Suave**: Liberação de endorfinas naturais

#### 😕 Confuso
- **Organização Mental (Brain Dump)**: Externalização de pensamentos
- **Passo a Passo**: Fragmentação de tarefas complexas
- **Respiração para Clareza**: Oxigenação cerebral

#### 😴 Cansado
- **Descanso Energético**: Micro-pausa restauradora
- **Respiração Energizante**: Ativação natural
- **Alongamento Despertar**: Movimento para aumentar energia

### 2. **Exercícios Interativos com Timer**

Cada exercício inclui:
- ⏱️ **Timer automático** por passo
- 📊 **Barra de progresso visual**
- ▶️ **Controles de play/pause/reiniciar**
- ✅ **Tela de conclusão com feedback**
- 📝 **Instruções passo a passo claras**

### 3. **Base Científica**

Todas as técnicas incluem:
- 🧠 Explicação da base neurocientífica
- ✨ Lista de benefícios comprovados
- 📚 Referências a métodos estabelecidos (Jacobson, EMDR, Temple Grandin, etc.)

### 4. **Integração com o Sistema**

O sistema se integra de múltiplas formas:

1. **Após registrar emoção**: Sugestão automática de técnicas personalizadas
2. **Durante seleção de emoção**: Acesso rápido antes de enviar ao professor
3. **Na página inicial**: Card de acesso rápido para autorregulação
4. **Menu principal**: Botão dedicado "Me Acalmar"

## Como Funciona

### Fluxo do Aluno

```
1. Aluno seleciona emoção (ex: "Ansioso")
   ↓
2. Sistema detecta que é emoção que precisa de apoio
   ↓
3. Oferece botão "Ir para Ferramentas de Autorregulação"
   ↓
4. Aluno vê 3 técnicas específicas para ansiedade
   ↓
5. Aluno escolhe uma técnica (ex: "Respiração 4-7-8")
   ↓
6. Sistema inicia exercício guiado com timer
   ↓
7. Aluno completa exercício
   ↓
8. Feedback positivo e opção de repetir ou escolher outra
```

### Componente Principal

**Localização**: `/components/student/SelfRegulation.tsx`

**Props**:
- `emotion?: string` - ID da emoção atual (opcional)
- `onBack: () => void` - Callback para voltar

**Estados**:
- `selectedTechnique` - Técnica atualmente selecionada
- `isExercising` - Se está executando exercício
- `exerciseStep` - Passo atual do exercício
- `countdown` - Timer do passo atual
- `completed` - Se completou o exercício

## Fundamentos Científicos

### Respiração 4-7-8
- **Base**: Dr. Andrew Weil
- **Mecanismo**: Ativa sistema nervoso parassimpático
- **Resultado**: Redução de cortisol em 23% (estudos)

### Técnica 5-4-3-2-1 (Grounding)
- **Base**: Terapia Cognitivo-Comportamental
- **Mecanismo**: Redireciona foco da amígdala para córtex sensorial
- **Resultado**: Redução imediata de ansiedade

### Abraço da Borboleta
- **Base**: EMDR (Eye Movement Desensitization and Reprocessing)
- **Mecanismo**: Estimulação bilateral promove processamento emocional
- **Resultado**: Regulação emocional equilibrada

### Relaxamento Muscular Progressivo
- **Base**: Edmund Jacobson (1920s)
- **Mecanismo**: Reduz ativação do sistema nervoso simpático
- **Resultado**: Diminuição de tensão e impulsos agressivos

### Pressão Profunda
- **Base**: Temple Grandin (pesquisadora autista)
- **Mecanismo**: Ativa receptores de pressão que liberam ocitocina
- **Resultado**: Sensação de segurança e redução de cortisol

## Adaptações para TEA/TOD

### Para TEA
- ✅ Instruções visuais claras e sequenciais
- ✅ Timers previsíveis e visíveis
- ✅ Feedback visual constante (barra de progresso)
- ✅ Opções de controle (pausar, reiniciar)
- ✅ Ambiente calmo sem sobrecarga sensorial

### Para TOD
- ✅ Técnicas de gestão de raiva validadas
- ✅ Ferramentas de consciência emocional (Termômetro da Raiva)
- ✅ Opções de escolha e autonomia
- ✅ Validação de emoções sem julgamento
- ✅ Estratégias de pausa antes da escalada

## Código de Exemplo

```tsx
// Uso básico
<SelfRegulation
  emotion="ansioso"
  onBack={() => setCurrentPage('home')}
/>

// Sem emoção específica (mostra técnicas gerais)
<SelfRegulation
  onBack={() => setCurrentPage('home')}
/>
```

## Personalização

Para adicionar novas técnicas, edite `getTechniquesForEmotion` em `/components/student/SelfRegulation.tsx`:

```tsx
confuso: [
  {
    id: 'nova-tecnica',
    name: 'Nome da Técnica',
    icon: Brain,
    type: 'breathing',
    duration: 120, // segundos
    description: 'Descrição breve',
    instructions: [
      'Passo 1',
      'Passo 2',
      'Passo 3'
    ],
    benefits: ['Benefício 1', 'Benefício 2'],
    scienceBasis: 'Explicação científica'
  }
]
```

## Métricas e Avaliação

O sistema pode ser expandido para incluir:
- [ ] Tracking de técnicas mais usadas
- [ ] Eficácia auto-reportada após exercício
- [ ] Correlação entre emoção e técnica preferida
- [ ] Sugestões inteligentes baseadas em histórico
- [ ] Gamificação (pontos por completar exercícios)

## Suporte e Recursos

Para professores, o sistema oferece:
- 📊 Visibilidade sobre quando alunos usam autorregulação
- 📈 Padrões de emoções que requerem mais suporte
- 🎯 Identificação de técnicas mais eficazes por aluno

## Acessibilidade

- ✅ Alto contraste visual
- ✅ Texto grande e legível
- ✅ Ícones intuitivos
- ✅ Feedback sonoro opcional
- ✅ Navegação simplificada
- ✅ Sem distrações desnecessárias

## Próximos Passos

Possíveis expansões futuras:
1. **Áudio guiado** para exercícios de respiração
2. **Vídeos demonstrativos** das técnicas
3. **Personalização de durações** por aluno
4. **Histórico de uso** e favoritos
5. **Notificações** para prática regular
6. **Integração com wearables** para biofeedback
7. **Modo offline** para uso sem internet

---

## Créditos Científicos

Este sistema foi desenvolvido com base em:
- Terapia Cognitivo-Comportamental (TCC)
- EMDR (Eye Movement Desensitization and Reprocessing)
- Pesquisas de Temple Grandin sobre TEA
- Mindfulness-Based Stress Reduction (MBSR)
- Dialectical Behavior Therapy (DBT)
- Relaxamento Progressivo de Jacobson

**Desenvolvido com 💜 para o Projeto LIDIA**
