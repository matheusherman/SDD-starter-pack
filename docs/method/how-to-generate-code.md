# How to Generate Code Using SDD

Este documento traz um guia de **como gerar código corretamente em Spec Driven Development**, sem cair em *vibe coding*.

A geração é uma operação controlada, repetível e previsível — não uma conversa.

---

## Regra fundamental

> Nunca gere código sem especificação completa.

Se você fornece apenas um prompt, você está codando artesanalmente com ajuda de IA.
Se você fornece specs + guardrails, você está operando em SDD.

> **Note:** A diferença entre SDD e "coding com IA" está nas entradas. SDD requer specs completas + guardrails, não apenas uma descrição vaga.

---

## Entradas obrigatórias para geração

Toda geração deve conter:

* Todas as specs de `/spec`
* O arquivo `AGENTS.md`
* Eventuais ADRs aplicáveis
* Regras de formatação e lint

A IA deve receber o **mundo completo do sistema**, não apenas a feature nova.

> **Tip:** Sempre inclua todas as specs relevantes, mesmo que esteja adicionando apenas uma feature. Isso garante que a nova feature se integre corretamente ao sistema existente.

---

## Papel do `AGENTS.md`

`AGENTS.md` define:

* Regras arquiteturais
* Padrões obrigatórios
* Convenções de código
* Regras de segurança
* Proibições explícitas

Ele funciona como o “manual da fábrica”.

---

## Fluxo correto de geração

1. Reúna specs + AGENTS.md
2. Envie para a IA como pacote único
3. Solicite geração completa
4. Receba código, testes e contratos
5. Valide contra as specs

Nunca gere apenas partes isoladas.

> **Note:** Gerar apenas partes isoladas pode criar inconsistências arquiteturais. Sempre gere o sistema completo ou a feature completa com suas dependências.

---

## Prompt padrão de geração

Use sempre o mesmo comando:

```
Generate the full system strictly following these specifications and guardrails.
Do not invent behavior. Do not omit rules. 
All behavior must be traceable to specs.
```

---

## Saídas esperadas

Uma geração válida produz:

* Código
* Testes
* Estrutura de projeto
* Configurações
* Documentação operacional mínima

Tudo deve ser derivado da spec.

---

## Regra de ouro

> Se você precisou explicar algo fora da spec, a spec está incompleta.

> **Tip:** Se você se encontrar explicando algo para a IA que não está na spec, pare e atualize a spec primeiro. Isso mantém a spec como fonte única da verdade.