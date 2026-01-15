# What is a Specification

Uma **especificação** é um blueprint executável que define, de forma explícita e testável, **como um sistema deve se comportar**. O código passa a ser apenas a materialização dessa definição.

Se algo não está na especificação, **não existe no sistema**.

> **Note:** Esta é uma regra absoluta em SDD. Não há exceções. Se você precisa de um comportamento, ele deve estar na spec.

---

## O que uma especificação define

Uma especificação descreve:

* Regras de negócio
* Comportamentos esperados
* Entradas e saídas
* Restrições e validações
* Requisitos não-funcionais (segurança, performance, etc.)

Ela responde claramente:

> “Dado X, o sistema deve responder Y.”

---

## Especificação ≠ prompt

Diferentemente de um prompt, **uma especificação não pede algo, ela define algo**.

Um prompt sugere.
Uma spec determina.

Um prompt descreve uma intenção.
Uma spec define um comportamento obrigatório.

---

### Exemplo – Prompt vs Specification

**Prompt:**

```
Crie um endpoint de login com validação de email e senha.
```

Esse texto é interpretativo, aberto e depende da “boa vontade” da IA para decidir:

* Como validar
* Quais erros retornar
* Quais regras aplicar
* Como integrar com o sistema

Cada execução pode gerar resultados diferentes.

---

**Specification:**

```
Endpoint: POST /api/auth/login

Input:
  email: string (must be valid email)
  password: string (min 8 chars)

Output:
  token: string
  user:
    id: string
    email: string
    name: string

Errors:
  400 INVALID_EMAIL
  400 PASSWORD_TOO_SHORT
  401 INVALID_CREDENTIALS

Rules:
  Rate limit: 5 requests per minute
  Must follow ADR-0001 Authentication Standard
```

Aqui não existe interpretação.
Existe **execução**.

> **Tip:** Use sempre linguagem determinística. Evite palavras como "pode", "deve tentar", "preferencialmente". Use "deve", "sempre", "nunca".

---

## Especificação ≠ documentação

| Documentação             | Especificação             |
| ------------------------ | ------------------------- |
| Descreve o que foi feito | Define o que deve existir |
| Fica desatualizada       | Evolui com o sistema      |
| É passiva                | É executável              |
| Não gera código          | Gera código               |

---


## Formatos comuns

Uma especificação pode ser escrita em:

* Markdown estruturado
* YAML
* JSON
* DSLs de especificação
* Linguagem natural estruturada

O formato é menos importante que:

* Clareza
* Completude
* Testabilidade
* Executabilidade

> **Note:** Escolha um formato e mantenha consistência. Markdown é popular por ser legível por humanos e processável por IAs.

---

## Exemplos

> Cada formato terá exemplos completos em arquivos próprios dentro de `/examples/spec-formats`.

O mesmo problema descrito em diferentes linguagens de especificação.

**Problema:** cálculo do total de um pedido com desconto e imposto.

Regras:

* Clientes PREMIUM recebem 10% de desconto
* Clientes REGULAR não recebem desconto
* Imposto é 8% aplicado sobre o valor após desconto

---

### Exemplo 1 – Markdown estruturado

```
Rule: Order pricing

Given:
  order.subtotal = X
  order.customer.type = REGULAR | PREMIUM

Then:
  if customer.type == PREMIUM:
      order.discount = X * 0.10
  else:
      order.discount = 0

  order.tax = (X - order.discount) * 0.08
  order.total = X - order.discount + order.tax
```

---

### Exemplo 2 – YAML

```yaml
rule: order_pricing
inputs:
  subtotal: number
  customer_type: [REGULAR, PREMIUM]

logic:
  discount:
    when:
      customer_type: PREMIUM
    value: subtotal * 0.10
    otherwise: 0

  tax: (subtotal - discount) * 0.08
  total: subtotal - discount + tax
```

---

### Exemplo 3 – JSON

```json
{
  "rule": "order_pricing",
  "inputs": {
    "subtotal": "number",
    "customer_type": ["REGULAR", "PREMIUM"]
  },
  "logic": {
    "discount": {
      "if": "customer_type == PREMIUM",
      "then": "subtotal * 0.10",
      "else": 0
    },
    "tax": "(subtotal - discount) * 0.08",
    "total": "subtotal - discount + tax"
  }
}
```

---

### Exemplo 4 – DSL simples

```
rule order_pricing:
  input subtotal number
  input customer_type REGULAR|PREMIUM

  when customer_type == PREMIUM:
    discount = subtotal * 0.10
  else:
    discount = 0

  tax = (subtotal - discount) * 0.08
  total = subtotal - discount + tax
```

---

> Specification is the blueprint.
