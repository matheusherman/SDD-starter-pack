# What is Spec Driven Development (SDD)

Spec Driven Development (SDD) é um modelo de desenvolvimento de software pautado no AI-First, onde **a [especificação](what-is-a-spec.md) é a fonte da verdade** e o código passa a ser **um artefato derivado**, não a origem do sistema.

Em SDD, você não “implementa funcionalidades”.
Você **projeta comportamentos através de [especificação](what-is-a-spec.md)** que são usadas por IAs para gerar código.

Hoje, na prática, a maioria dos projetos “vive” dentro do código.
Para entender o que um sistema faz, é necessário ler implementações, seguir fluxos, interpretar decisões implícitas e reconstruir mentalmente o comportamento do software.

Em SDD, o sistema existe primeiro na [especificação](what-is-a-spec.md).
O código é apenas uma materialização automática dessas regras.

O papel do humano muda de executor para arquiteto.
O papel da IA muda de assistente para força de trabalho.

---

## O problema atual

Mesmo com frameworks modernos e IA, o desenvolvimento continua artesanal:

* Código contém a regra de negócio
* Especificações são vagas ou inexistentes
* Conhecimento fica implícito
* Mudanças exigem leitura e refatoração manual
* Projetos ficam progressivamente mais difíceis de manter

Resultado:

* Alto custo de manutenção
* Refatorações destrutivas
* Dependência de pessoas específicas
* Baixa previsibilidade
* Escalabilidade limitada

---

## A inversão do SDD

SDD inverte a lógica tradicional:

| Modelo Tradicional           | SDD                            |
| ---------------------------- | ------------------------------ |
| Código é a verdade           | Especificação é a verdade      |
| Documentação descreve código | Código executa a especificação |
| Refatorar                    | Regenerar                      |
| Mudança é risco              | Mudança é operação normal      |
| Escala por pessoas           | Escala por processo            |

---

## [Especificações](what-is-a-spec.md)

Em SDD, especificações não são documentação.
Elas são **blueprints executáveis**:

* Versionadas como código
* Processadas por IA
* Testáveis e auditáveis
* Capazes de regenerar o sistema inteiro

Você pode apagar o código e reconstruí-lo a qualquer momento a partir das specs.

---

## O novo fluxo de trabalho

```
Ideia → Contexto → Especificação → Geração por IA → Validação → Deploy
```

A iteração acontece na especificação, não no código.

---

## O que muda na prática

* Você modifica specs, não código
* Mudanças deixam de ser destrutivas
* Migrações de stack tornam-se triviais
* Onboarding vira leitura de especificação
* Conhecimento deixa de ser tácito

---

## Resultado

SDD transforma software em um processo industrial.

Você deixa de “manter código”
e passa a **manter sistemas através de especificação.**

---

> You are the architect.
> IA is the workforce.
> Specification is the blueprint.
