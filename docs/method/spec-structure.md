# Specification Structure

Este documento aborda o **padrão estrutural oficial de especificações no SDD Starter Pack**.

Ele estabelece como organizar, nomear e versionar specs para que sistemas sejam **previsíveis, regeneráveis e auditáveis**.

---

## Por que estrutura importa

Sem padrão estrutural:

* Specs ficam espalhadas
* Regras se perdem
* O sistema vira novamente código implícito
* Regeneração se torna imprevisível

Com estrutura, o sistema vira um **blueprint organizado**.

> [!NOTE]
> A estrutura não é apenas organização. Ela define a ordem de leitura e processamento das specs pela IA.

---

## Estrutura base do projeto

Todo projeto SDD deve conter:

```
/spec
  00-general-context.spec.md
  00-architecture.spec.md
  00-stack.spec.md
  01-<feature>.spec.md
  02-<feature>.spec.md
  ...
```

---

## 00-general-context.spec.md

Define o terreno do sistema.

Contém:

* Nome do sistema
* Domínio
* Propósito
* Atores
* Objetivo principal

Exemplo:

```
System: Billing System
Domain: Finance
Purpose: Manage invoices and payments
Actors: Customer, Admin, System
```

---

## 00-architecture.spec.md

Define decisões arquiteturais:

* Camadas
* Componentes
* Responsabilidades
* Integrações
* Regras estruturais

Ela impede que a IA "invente arquitetura".

> [!TIP]
> Sem um arquivo de arquitetura explícito, cada geração pode produzir estruturas diferentes. Defina a arquitetura antes de gerar código.

---

## 00-stack.spec.md

Define:

* Linguagem
* Framework
* Banco
* Infra
* Padrões obrigatórios

Ela ancora a geração.

---

## 01-*.spec.md (Features)

Cada feature é isolada em sua própria spec:

* API
* Regras
* Fluxos
* Erros
* Restrições

Uma feature = um arquivo.

---

## Versionamento

Specs são código:

* Mudanças via PR
* Histórico versionado
* Revisão obrigatória
* Testes baseados em spec

---

## Ordem importa

* `00-*` define o mundo
* `01+` define o sistema

O código é sempre consequência.

---

## Regra fundamental

> Um sistema SDD é completamente reconstruível apenas pela pasta `/spec`.

> [!NOTE]
> Use esta regra como teste. Se você apagar todo o código e não conseguir regenerar o sistema apenas com as specs, algo está faltando na especificação.
