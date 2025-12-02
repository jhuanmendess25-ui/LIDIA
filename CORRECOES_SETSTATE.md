# 🔧 CORREÇÕES DE SETSTATE - PROJETO LIDIA

## ❌ Problema Identificado

**Erro:** `Warning: Cannot update a component while rendering a different component`

### Causa
O erro ocorria porque estávamos chamando `onPoints()` (que atualiza o estado do componente pai `TherapeuticGames`) durante o render ou dentro de callbacks de setState dos jogos filhos.

### Regra do React
❌ **NUNCA** chame setState de um componente pai durante o render de um componente filho  
✅ **SEMPRE** use `useEffect`, `setTimeout`, ou callbacks de eventos

---

## ✅ CORREÇÕES IMPLEMENTADAS

### 1. Bolhas Mágicas

#### ❌ Antes (Errado)
```typescript
setBubbles(prev => prev.filter(bubble => {
  const distance = Math.sqrt((x - bubble.x) ** 2 + (y - bubble.y) ** 2);
  if (distance < bubble.radius && !popped) {
    popped = true;
    setScore(s => {
      const newScore = s + 1;
      if (newScore % 10 === 0) {
        onPoints(5); // ❌ Chamando setState do pai durante render
      }
      return newScore;
    });
    return false;
  }
  return true;
}));
```

#### ✅ Depois (Correto)
```typescript
// Usar ref para rastrear último score que deu pontos
const lastPointsScore = useRef(0);

// handleCanvasClick - apenas atualiza score
setScore(s => s + 1);

// useEffect separado para dar pontos
useEffect(() => {
  if (score > 0 && score % 10 === 0 && score !== lastPointsScore.current) {
    lastPointsScore.current = score;
    onPoints(5); // ✅ Agora está em useEffect
  }
}, [score, onPoints]);
```

---

### 2. Jogo da Memória

#### ❌ Antes (Errado)
```typescript
setMatches(m => {
  const newMatches = m + 1;
  if (newMatches === emojis.length) {
    onPoints(50); // ❌ Dentro de setState
  } else {
    onPoints(10); // ❌ Dentro de setState
  }
  return newMatches;
});
```

#### ✅ Depois (Correto)
```typescript
// Apenas atualizar estado
setMatches(m => m + 1);

// useEffect separado para pontos
useEffect(() => {
  if (matches > 0 && matches <= emojis.length) {
    if (matches === emojis.length) {
      onPoints(50);
      setTimeout(() => alert('Parabéns! 🎉'), 100);
    } else {
      onPoints(10);
    }
  }
}, [matches, emojis.length, onPoints]);
```

---

### 3. Respiração Guiada

#### ❌ Antes (Errado)
```typescript
setCycles(prev => {
  const newCycles = prev + 1;
  if (newCycles % 3 === 0) {
    onPoints(10); // ❌ Dentro de setState
  }
  return newCycles;
});
```

#### ✅ Depois (Correto)
```typescript
// Apenas atualizar ciclos
setCycles(prev => prev + 1);

// useEffect separado
useEffect(() => {
  if (cycles > 0 && cycles % 3 === 0) {
    onPoints(10); // ✅ Em useEffect
  }
}, [cycles, onPoints]);
```

---

### 4. Padrões Visuais

#### ❌ Antes (Errado)
```typescript
if (newUserPattern.length === pattern.length) {
  const points = level * 5;
  onPoints(points); // ❌ Chamado durante validação
  setScore(s => s + points);
  setLevel(l => Math.min(l + 1, 6));
}
```

#### ✅ Depois (Correto)
```typescript
if (newUserPattern.length === pattern.length) {
  const points = level * 5;
  setScore(s => s + points);
  setLevel(l => Math.min(l + 1, 6));
  setTimeout(() => {
    alert(`Parabéns! +${points} pontos! 🎉`);
    onPoints(points); // ✅ Dentro de setTimeout
    generatePattern();
  }, 300);
}
```

---

### 5. Simon (Sequência de Cores)

#### ✅ Correção
```typescript
// Mover onPoints para dentro do setTimeout
setTimeout(() => {
  onPoints(points); // ✅ Dentro de setTimeout
  const newSeq = [...sequence, Math.floor(Math.random() * 4)];
  setSequence(newSeq);
  playSequence(newSeq);
}, 100);
```

---

### 6. Quebra-Cabeça

#### ✅ Correção
```typescript
if (solved) {
  setIsSolved(true);
  setTimeout(() => {
    onPoints(100); // ✅ Dentro de setTimeout
    alert(`Parabéns! 🎉`);
  }, 100);
}
```

---

### 7. Sudoku 4×4

#### ✅ Correção
```typescript
if (isComplete) {
  setTimeout(() => {
    onPoints(150); // ✅ Dentro de setTimeout
    alert('Parabéns! 🎉');
  }, 100);
}
```

---

### 8. Desafio Matemático

#### ✅ Correção
```typescript
if (userNum === question.answer) {
  const points = difficulty === 'easy' ? 5 : difficulty === 'medium' ? 10 : 20;
  setScore(s => s + points);
  setStreak(s => s + 1);
  setTimeout(() => onPoints(points), 0); // ✅ setTimeout com 0ms
  generateQuestion();
}
```

---

### 9. Labirinto

#### ✅ Correção
```typescript
if (newX === endPos.x && newY === endPos.y) {
  setIsComplete(true);
  setTimeout(() => {
    onPoints(200); // ✅ Dentro de setTimeout
    alert(`Parabéns! 🎉`);
  }, 100);
}
```

---

### 10. Desenho Livre

#### ✅ Correção
```typescript
const saveDrawing = () => {
  setSavedDrawings(prev => prev + 1);
  setTimeout(() => onPoints(15), 0); // ✅ setTimeout
  alert('Desenho salvo! 🎨');
};
```

---

## 📊 RESUMO DAS TÉCNICAS APLICADAS

### Técnica 1: useEffect Separado
**Quando usar:** Pontos baseados em mudança de estado

```typescript
useEffect(() => {
  if (condition) {
    onPoints(value);
  }
}, [dependency, onPoints]);
```

**Jogos:** Bolhas, Memória, Respiração

---

### Técnica 2: setTimeout
**Quando usar:** Pontos ao completar ação

```typescript
setTimeout(() => {
  onPoints(value);
  // outras ações
}, 0 ou 100);
```

**Jogos:** Padrões, Simon, Quebra-Cabeça, Sudoku, Matemática, Labirinto, Desenho

---

### Técnica 3: Ref para Rastreamento
**Quando usar:** Evitar chamadas duplicadas

```typescript
const lastPointsScore = useRef(0);

useEffect(() => {
  if (score !== lastPointsScore.current) {
    lastPointsScore.current = score;
    onPoints(value);
  }
}, [score]);
```

**Jogos:** Bolhas

---

## ✅ VERIFICAÇÃO FINAL

### Checklist de Correções

- [x] **Bolhas Mágicas** - useEffect + ref
- [x] **Jogo da Memória** - useEffect separado
- [x] **Respiração Guiada** - useEffect separado
- [x] **Padrões Visuais** - setTimeout
- [x] **Simon** - setTimeout
- [x] **Quebra-Cabeça** - setTimeout
- [x] **Sudoku** - setTimeout
- [x] **Matemática** - setTimeout
- [x] **Labirinto** - setTimeout (2 lugares)
- [x] **Desenho Livre** - setTimeout

### Resultado
✅ **TODOS os erros de setState corrigidos**  
✅ **NENHUM warning no console**  
✅ **Todos os jogos funcionando normalmente**  
✅ **Sistema de pontos funcionando**

---

## 🎓 LIÇÕES APRENDIDAS

### 1. React Rendering Rules
- ❌ Nunca chame setState de componente pai durante render do filho
- ✅ Use useEffect para efeitos colaterais
- ✅ Use setTimeout para atrasar atualizações

### 2. Parent-Child Communication
- Props são para passar dados **para baixo**
- Callbacks são para comunicar **para cima**
- Callbacks devem ser chamados em **eventos** ou **effects**, não durante render

### 3. Best Practices
- Separe lógica de pontuação da lógica de jogo
- Use useEffect para observar mudanças de estado
- Use setTimeout(fn, 0) para quebrar o ciclo de render

---

## 🔍 COMO IDENTIFICAR O ERRO

### Sintomas
```
Warning: Cannot update a component (`TherapeuticGames`) 
while rendering a different component (`BubblesGame`)
```

### Procurar por:
1. `onPoints()` dentro de `setState` callback
2. `onPoints()` durante validações/verificações
3. `onPoints()` em funções chamadas durante render

### Soluções:
1. Mover para `useEffect`
2. Envolver em `setTimeout`
3. Usar refs para controle

---

## ✨ CONCLUSÃO

Todas as correções foram implementadas com sucesso. O sistema agora segue as melhores práticas do React e não apresenta warnings no console.

**Status:** ✅ CORRIGIDO E TESTADO

**Data:** 28 de Novembro de 2025

---

**Desenvolvido com ❤️ seguindo as melhores práticas do React**
