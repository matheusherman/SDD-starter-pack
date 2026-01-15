# The SDD Workflow

Este documento trata do **fluxo operacional padrão do Spec Driven Development**.

Ele substitui o fluxo artesanal de “codar → corrigir → refatorar” por um processo previsível, regenerável e controlável.

---

## Visão geral

Em SDD, o sistema não nasce no código.
Ele nasce na especificação.

```
Ideia → Contexto → Especificação → Geração → Validação → Iteração → Deploy
```

Todo trabalho acontece **antes do código existir**.

> [!NOTE]
> Em SDD, você investe tempo pensando e especificando antes de gerar código. Isso pode parecer mais lento, mas reduz drasticamente o tempo de refatoração e manutenção.

---

## 1. Ideia

Uma ideia representa qualquer intenção de mudança:

* Nova funcionalidade
* Ajuste de regra
* Correção de comportamento
* Migração de stack
* Evolução de arquitetura

Aqui ainda não existem decisões técnicas.
Existe apenas intenção de negócio.

---

## 2. Contexto

A ideia é convertida em contexto:

* Domínio afetado
* Atores envolvidos
* Sistema atual
* Impactos esperados
* Restrições existentes

Isso forma a **Especificação Zero**, que define o “terreno” onde o sistema será projetado.

---

## 3. Especificação

Aqui o sistema é **formalmente projetado**.

Você define:

* Contratos de API
* Regras de negócio
* Fluxos de estado
* Requisitos de segurança
* Requisitos de performance
* Restrições técnicas

A especificação remove ambiguidades antes que o código exista.

> [!TIP]
> Quanto mais tempo você investir na especificação, menos tempo gastará corrigindo bugs e refatorando código gerado.

---

## 4. Geração

As especificações são fornecidas à IA junto com `AGENTS.md`.

A IA:

* Gera o código
* Gera testes
* Gera documentação operacional
* Respeita os guardrails definidos

O código nasce como uma **materialização exata do blueprint**.

> [!NOTE]
> O código gerado não deve conter decisões não especificadas. Se encontrar algo assim, a spec precisa ser mais completa.

---

## 5. Validação

A validação acontece **contra a especificação**, não contra o código.

Você valida:

* Respostas de API
* Regras de cálculo
* Estados válidos
* Casos de erro
* Segurança e restrições

O código só é aceito se corresponder integralmente às specs.

---

## 6. Iteração

Qualquer ajuste ocorre **exclusivamente na especificação**:

* Mudança de regra
* Novo fluxo
* Nova validação
* Alteração de requisito

O código é regenerado.

---

## 7. Deploy

Você faz deploy de um sistema:

* Previsível
* Rastreável
* Regenerável
* Totalmente documentado por specs

---

## Regra de ouro

> Nunca corrija o código.
> Sempre corrija o blueprint.

> [!TIP]
> Esta é a regra de ouro do SDD. Se você encontrar um bug, não edite o código. Corrija a spec e regenere. Isso mantém o sistema regenerável.
