# Guardrails in Spec Driven Development

Este documento define **o papel dos guardrails em projetos SDD** e como eles transformam IA de “gerador imprevisível” em **executor confiável de blueprints**.

Sem guardrails, você não tem SDD.
Você tem *vibe coding com esteroides*.

---

## O que são guardrails

Guardrails são **regras formais que limitam e direcionam a execução da IA**.

Eles definem:

* O que a IA pode fazer
* O que a IA não pode fazer
* Como a IA deve interpretar specs
* Como o código deve ser estruturado
* Quais padrões são obrigatórios

Guardrails transformam a IA em **força de trabalho industrial**, não em artista criativo.

---

## Onde os guardrails vivem

Os guardrails vivem principalmente em:

* `AGENTS.md`
* `00-architecture.spec.md`
* `00-stack.spec.md`
* ADRs
* Regras de CI/CD

Eles fazem parte do sistema, não do processo humano.

---

## O problema sem guardrails

Sem guardrails:

* Cada geração produz arquiteturas diferentes
* Padrões se perdem
* Segurança varia
* Código vira novamente artesanal
* Regeneração se torna imprevisível

O sistema deixa de ser regenerável.

---

## Tipos de guardrails

### 1. Guardrails de arquitetura

Definem:

* Camadas permitidas
* Dependências proibidas
* Comunicação entre módulos
* Regras de acoplamento

Exemplo:

```
Rule:
  Controllers must not access repositories directly.
```

---

### 2. Guardrails de stack

Definem:

* Linguagens permitidas
* Frameworks obrigatórios
* Banco de dados
* Infraestrutura
* Ferramentas de build

Eles impedem “invenção de stack”.

---

### 3. Guardrails de segurança

Definem:

* Autenticação obrigatória
* Criptografia
* Rate limiting
* Validação de input
* Padrões OWASP mínimos

---

### 4. Guardrails de qualidade

Definem:

* Padrões de código
* Cobertura mínima
* Linters obrigatórios
* Formatação
* Nomenclatura

---

### 5. Guardrails de comportamento

Definem:

* Regras que a IA nunca pode violar
* Fluxos proibidos
* Casos inválidos
* Estados impossíveis

---

## Guardrails como contrato da fábrica

Guardrails não são “boas práticas”.
Eles são **leis do sistema**.

A IA não tem permissão para “interpretar” guardrails.

---

## AGENTS.md – o coração dos guardrails

Exemplo:

```
# Architectural Guardrails

- All APIs must be REST
- No direct DB access from controllers
- All endpoints must return standardized error format
- All logic must live in services

# Security Guardrails

- All endpoints require authentication
- Rate limit: 100/min
```

---

## Guardrails + Specs = Sistema executável

Sem guardrails, a spec vira sugestão.
Com guardrails, a spec vira **lei**.



## Regra de ouro

> Se a IA pode inventar, você não tem SDD.
