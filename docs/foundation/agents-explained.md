# AGENTS.md (Versão Comentada)

## SDD Starter Pack — AI Guardrails Explained

Este documento explica os guardrails oficiais do SDD Starter Pack e **por que eles são obrigatórios para que SDD funcione como método e não como “prompting melhorado”.**

---

## 1. Especificação como fonte da verdade

### Regra

> A IA não pode gerar comportamento que não esteja explicitamente na spec.

### Por quê

Sem essa regra, o sistema volta a ser artesanal.
Cada geração vira uma “interpretação criativa” da IA, e o código deixa de ser regenerável.

Essa regra garante:

* Previsibilidade
* Reprodutibilidade
* Rastreabilidade
* Controle de comportamento

> **Note:** Sem essa regra, cada geração pode produzir código diferente, mesmo com as mesmas specs. Isso quebra a regenerabilidade.

---

## 2. Proibição de invenção

### Regra

> A IA não pode “completar” regras que não estejam na spec.

### Por quê

Toda invenção vira **regra implícita**, e regra implícita mata SDD.

Essa regra força o humano a:

* Pensar o sistema
* Formalizar decisões
* Transformar conhecimento em blueprint

> **Tip:** Se você está tendo dificuldade em escrever specs completas, comece pequeno. Uma spec incompleta é melhor que nenhuma spec.

---

## 3. Separação de responsabilidades

### Regra

> API, Services, Rules e Flows são camadas distintas.

### Por quê

Sem isso, regras começam a se espalhar novamente pelo código,
o sistema volta a ter comportamento implícito.

Essa regra mantém o código **regenerável e auditável**.

---

## 4. Testes obrigatórios

### Regra

> Toda regra especificada deve gerar testes.

### Por quê

Sem testes, você não tem validação de blueprint.
Você tem apenas “confiança”.

Testes tornam a spec **executável de verdade**.

> **Note:** Testes não são opcionais em SDD. Eles são a validação de que o código gerado corresponde à especificação.

---

## 5. Segurança por padrão

### Regra

> Endpoints são protegidos por padrão.

### Por quê

Segurança implícita é um dos maiores problemas de sistemas artesanais.
Aqui ela vira **lei de sistema**, não decisão de programador.

---

## 6. Erros explícitos

### Regra

> Só existem erros que estão na spec.

### Por quê

Erros implícitos geram comportamento imprevisível.
Isso quebra validação, rastreabilidade e regeneração.

---

## 7. Regenerabilidade total

### Regra

> O sistema deve poder ser apagado e regenerado integralmente.

### Por quê

Isso é o que permite:

* Refatoração infinita sem medo
* Migração de stack
* Evolução limpa

---

## 8. Documentação derivada da spec

### Regra

> Documentação também deve ser gerada.

### Por quê

Isso elimina documentação manual, que sempre fica desatualizada.

---

## 9. Regra-mãe do SDD

> Se a IA puder adivinhar, o sistema já morreu.

> **Tip:** Use esta regra como teste. Se você ler uma spec e pensar "a IA pode adivinhar o que fazer aqui", a spec precisa ser mais específica.
