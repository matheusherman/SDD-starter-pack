# How to Validate and Iterate in SDD

Este documento define **como validar, evoluir e refatorar sistemas usando apenas especificação**, sem tocar manualmente no código.

Em SDD, validar e iterar não é “consertar código”.
É **ajustar blueprints e regenerar sistemas.**

---

## Validação sempre contra a spec

Nunca valide “se funciona”.
Valide sempre:

> “O sistema se comporta exatamente como a especificação define?”

---

## O que validar

Toda geração deve ser validada contra:

* Contratos de API
* Regras de negócio
* Fluxos de estado
* Erros e exceções
* Segurança e restrições
* Performance mínima

---

## Como validar

Validação acontece em três níveis:

### 1. Validação automática

* Testes gerados por spec
* Linters e formatadores
* Checagem estrutural

---

### 2. Validação funcional

* Cenários de uso
* Casos de borda
* Estados inválidos
* Erros esperados

---

### 3. Validação de contrato

* Entradas
* Saídas
* Códigos de erro
* Regras de segurança

---

## Iteração correta

Toda iteração começa pela spec.

| Errado                | Correto             |
| --------------------- | ------------------- |
| Mudar código          | Mudar especificação |
| Corrigir bug direto   | Corrigir regra      |
| Refatorar manualmente | Regenerar sistema   |

---

## Ciclo de iteração

```
Bug → Ajuste de spec → Regeneração → Validação → Deploy
```

---

## Controle de evolução

Cada mudança gera:

* Diff de spec
* Histórico claro
* Rastreabilidade
* Reversibilidade total

---

## Resultado

O sistema nunca envelhece.
Ele é continuamente regenerável.

---

## Regra final

> O código é descartável.
> A especificação é o sistema.