# How to Write Good Specifications

Este documento apresenta **como escrever especificações que realmente funcionam como blueprints executáveis**.

SDD só funciona se as specs forem claras, completas e testáveis.

---

## Princípio central

> Se a IA precisar “adivinhar”, a especificação está incompleta.

Uma boa spec não deixa decisões implícitas.

---

## Comece sempre pelo comportamento

Nunca comece pela tecnologia.
Comece sempre pelo comportamento.

Pergunte:

* O que o sistema deve fazer?
* Em quais condições?
* Com quais respostas?
* Com quais restrições?

---

## Estrutura mínima de uma boa spec

Toda spec deve conter:

| Bloco   | Função                                |
| ------- | ------------------------------------- |
| Context | Onde essa spec se aplica              |
| Inputs  | O que entra                           |
| Outputs | O que sai                             |
| Regras  | O que deve ser obedecido              |
| Erros   | O que acontece quando algo é inválido |

---

## Use linguagem determinística

Evite:

* “Deve tentar”
* “Pode”
* “Preferencialmente”
* “Se possível”

Use:

* Must
* Must not
* Always
* Never

---

## Especifique erros explicitamente

Todo erro deve ser definido:

* Código
* Condição
* Resposta

Nada deve “falhar silenciosamente”.

---

## Exemplo ruim

```
Crie um login seguro.
```

---

## Exemplo bom

```
Endpoint: POST /api/auth/login

Input:
  email: valid email
  password: min 8 chars

Errors:
  400 INVALID_EMAIL
  401 INVALID_CREDENTIALS

Rules:
  Rate limit: 5/min
```

---

## Especificação é código

Versione specs.
Revise specs.
Valide specs.

O código apenas executa.

---

Próximo:

`/docs/method/spec-structure.md`
