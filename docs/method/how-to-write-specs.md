# How to Write Good Specifications

Este documento apresenta **como escrever especificações que realmente funcionam como blueprints executáveis**.

SDD só funciona se as specs forem claras, completas e testáveis.

---

## Princípio central

> Se a IA precisar "adivinhar", a especificação está incompleta.

Uma boa spec não deixa decisões implícitas.

> **Note:** Use este princípio como teste. Se você ler sua spec e pensar "a IA pode adivinhar o que fazer aqui", a spec precisa ser mais específica.

---

## Comece sempre pelo comportamento

Nunca comece pela tecnologia.
Comece sempre pelo comportamento.

Pergunte:

* O que o sistema deve fazer?
* Em quais condições?
* Com quais respostas?
* Com quais restrições?

> **Tip:** Comece sempre respondendo essas perguntas antes de escrever a spec. Isso garante que você está definindo comportamento, não implementação.

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

Nada deve "falhar silenciosamente".

> **Note:** Todo erro deve ser explícito. Se algo pode dar errado, defina o código de erro, a mensagem e a condição que o dispara.

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

> **Tip:** Trate specs como código. Use Git, faça code review, mantenha histórico. A spec é o ativo mais valioso do projeto.

---

Próximo:

`/docs/method/spec-structure.md`
