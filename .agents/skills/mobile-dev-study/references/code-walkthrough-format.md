# Code Walkthrough & Refactoring Format — Mobile Development

Reference file for `mobile-dev-study`. Outlines the post-feature code walkthrough and refactoring review format (`[XX].[Y]-[slug].md`).

---

## 📌 Purpose

After the student attempts or completes an app feature, the `mobile-dev-tutor` generates a lightweight code walkthrough document to review architecture, clean code, performance, and state flow.

---

## 📝 Document Structure (4 Mandatory Sections)

```markdown
# 📱 Feature Review: [Nome da Feature / Componente]

## 1. Conceito Consolidado
[Resumo de 2-3 frases sobre o componente ou padrão de estado construído pelo aluno, destacando por que a solução funciona bem na arquitetura mobile.]

## 2. Raciocínio & Arquitetura

### 🎯 Causa Raiz & Motivação
[Explicação da necessidade técnica que este componente atende — ex: separação de regras de negócio da UI, gerenciamento de estado assíncrono.]

### 🔄 Cadeia de Decisão
- **Identificação da necessidade:** [ex: Tela precisava carregar dados assíncronos ao abrir]
- **Escolha do padrão:** [ex: ViewModel + Flow / Custom Hook]
- **Efeito observado:** [ex: UI reage automaticamente às mudanças de estado sem re-renderizar partes desnecessárias]

### 🚨 Sinal de Reconhecimento (Smells & Performance)
Checklist mental para identificar quando aplicar ou refatorar esse padrão no futuro:
- [ ] Re-renderizações excessivas detectadas durante a digitação no input
- [ ] Lógica de API misturada diretamente na árvore de componentes de UI
- [ ] Vazamento de memória por falta de cancelamento de subscriptions no ciclo de vida

## 3. Cheat Sheet / Referência Rápida

Snippets de assinaturas limpas e padrões recomendados (sempre agnósticos ou com exemplos genéricos):

```typescript
// Exemplo genérico de Hook de Estado Reativo
export const useFeatureState = <T>(initialData: T) => {
  // Lógica genérica de estado
};
```

## 4. Checklist de Progresso & Próximos Passos

- [x] Feature [Nome da Feature] implementada no codebase do app
- [ ] Avançar para o próximo componente: [[./MISSAO.md|Ver MISSAO.md]]

---

### 🔗 Retake Bridges

Se você encontrou dificuldades na implementação deste componente, revise os conceitos-chave:
- [[../prerequisites/[pasta]/[arquivo].md|Nome do Conceito]]
```
