# AGENTS.md

## SDD Starter Pack — AI Guardrails

Este arquivo define **guardrails (regras firmes de execução)** que a IA deve seguir ao gerar código a partir das especificações.
Ele garante consistência, conformidade com arquitetura e padrões obrigatórios.

> **Note:** Este arquivo é obrigatório para qualquer projeto SDD. Sem ele, a IA pode gerar código inconsistente ou que viole seus padrões arquiteturais.

---

## 1. REGRAS GERAIS

### 1.1 “Especificação é a fonte da verdade”

A IA **não deve gerar nenhum comportamento que não esteja explicitamente declarado nas specs** em `/spec`.
Qualquer funcionalidade adicional precisa antes ser adicionada à especificação.

> **Note:** Esta é a regra mais importante do SDD. Violá-la significa voltar ao modelo artesanal onde o código contém regras implícitas.

### 1.2 Não inventar

A IA **não pode inferir, adivinhar ou completar regras que não estejam escritas na spec**.
Se a spec estiver incompleta, gere um erro de validação pedindo que a spec seja completada.

> **Tip:** Se a IA sugerir funcionalidades "úteis" não especificadas, adicione-as primeiro à spec antes de aceitar a geração.

### 1.3 Não modifique specs

A IA nunca altera diretamente arquivos de spec.
Mudanças de comportamento requerem que os humanos atualizem as specs manualmente.

---

## 2. ARQUITETURA & ORGANIZAÇÃO

### 2.1 Estrutura do projeto

A IA deve gerar a estrutura de projeto seguindo este padrão:

```
/src
  /api
  /services
  /rules
  /flows
/tests
/config
```

Arquivos de spec nunca devem ser inseridos em `/src`.

> **Note:** A separação entre `/spec` e `/src` é fundamental. Especificações são blueprints, não código executável.

### 2.2 Separação de responsabilidades

* **API controllers** manipulam requisições e respostas.
* **Services** contêm lógica principal extraída das specs.
* **Rules modules** implementam regras de negócio.
* **Flows modules** implementam transições de estados.

A IA não deve colocar regras de negócio dentro de controllers.

> **Tip:** Se você encontrar lógica de negócio em controllers, isso indica que a spec não foi seguida corretamente. Regenerar o código pode resolver o problema.

---

## 3. PADRÕES DE CÓDIGO

### 3.1 Linguagem e estilo

* Seguir o padrão de codificação da linguagem escolhida (ex.: ESLint/Prettier em JS, Black/Flake8 em Python).
* Todos os arquivos gerados devem passar nas ferramentas de lint configuradas.
* Evitar estilos não padronizados ou “gambiarras”.

### 3.2 Testes obrigatórios

Para cada módulo gerado, a IA deve criar **testes automatizados** que cobrem:

* Casos de sucesso
* Casos de erro
* Regras explícitas da spec

> **Note:** Testes são parte do sistema, não opcionais. Eles validam que o código gerado corresponde exatamente à especificação.

---

## 4. API

### 4.1 Formato de resposta padrão

Todas as APIs REST devem seguir este contrato mínimo:

```
{
  "status": "success" | "error",
  "data": <object | null>,
  "error": {
    "code": string,
    "message": string
  }
}
```

A IA deve usar esse formato para **todas as respostas**, incluindo erros.

> **Tip:** Este formato padronizado facilita o tratamento de erros no frontend e garante consistência em toda a API.

### 4.2 Validações de entrada

A IA deve gerar validações de entrada que:

* Correspondam ao tipo esperado (string, number, etc.)
* Retornem erros claros (ex.: `400 INVALID_EMAIL`)
* Não permitam comportamento não especificado

---

## 5. SEGURANÇA

### 5.1 Autenticação e autorização

* APIs públicas devem obrigatoriamente exigir autenticação se a spec indicar.
* Se uma spec não declarar que um endpoint é público, a IA deve **assumir que ele precisa de autorização por padrão**.

> **Note:** Segurança por padrão é uma prática essencial. Endpoints públicos devem ser explicitamente declarados na spec.

### 5.2 Proteções básicas

A IA deve gerar verificações de segurança padrão:

* Rate limiting básico (conforme spec)
* Sanitização de entradas
* Resposta de erro padronizada sem vazar detalhes internos

---

## 6. ERROS & LOGS

### 6.1 Erros explicitamente especifícados

Erro de negócio ou de validação só pode existir se estiver declarado na spec.
Exemplo:

```
Errors:
  401 INVALID_CREDENTIALS
```

Esse item deve ser gerado como erro de API.

### 6.2 Logs

A IA deve gerar logs mínimos em operações chave:

* Criação de recursos
* Erros de validação
* Transições de estados incomuns

Logs não devem expor dados sensíveis.

---

## 7. RESTRIÇÕES DE COMPORTAMENTO

### 7.1 Não gerar features não especificadas

Se a IA identificar algo “útil mas não especifícado”, ela deve:

* **Abortar a geração**
* **Retornar uma mensagem de erro**
* **Pedir que o autor da spec adicione a regra antes de continuar**

### 7.2 Regenerabilidade

Todo código gerado deve poder ser completamente apagado e regenerado a partir das mesmas specs + podem ser reproduzido com resultados equivalentes.

> **Note:** A regenerabilidade total é o que permite refatorações sem medo, migrações de stack e evolução contínua do sistema.

---

## 8. QUALIDADE E DOCUMENTAÇÃO

### 8.1 Documentação interna

A IA deve inserir comentários que:

* Explique ligação entre código e spec correspondente
* Cite a seção da spec que motivou cada bloco gerado

### 8.2 README e instruções

A IA deve gerar ou atualizar automaticamente:

* Scripts de rodar o sistema
* Scripts de testes
* Exemplos de uso de APIs

---

## 9. PADRÕES DE RELEASE

### 9.1 Versionamento

O sistema gerado deve seguir **versionamento semântico (SemVer)**.

### 9.2 Changelog automático

A IA deve gerar um changelog resumido com:

* Quais specs mudaram
* O impacto esperado

---

## USO TÍPICO

Ao enviar specs + `AGENTS.md` para a IA, use o seguinte comando padrão:

```
Generate the full system following these specifications and guardrails.
Do not invent or assume behavior not defined in spec.
Return code + tests + documentation.
```

> **Tip:** Sempre inclua o `AGENTS.md` junto com as specs ao solicitar geração de código. Ele garante que a IA siga seus padrões arquiteturais e de qualidade.