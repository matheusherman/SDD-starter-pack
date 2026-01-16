# How to Create a New SDD Project

Este guia mostra **como criar um projeto novo do zero usando Spec Driven Development**, passo a passo, criando um exemplo prático e funcional.

Você vai aprender a estruturar um projeto SDD completo, desde a configuração inicial até a primeira geração de código, tudo usando **Linux e VS Code**.

---

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

* **Linux** (Ubuntu, Debian, Fedora, ou qualquer distribuição)
* **Git** (`sudo apt install git` ou equivalente)
* **VS Code** ([download aqui](https://code.visualstudio.com/))
* **Um modelo de IA** (GitHub Copilot, Claude, GPT-4, ou modelo local)
* **Terminal básico** (saber navegar com `cd`, `ls`, `mkdir`)

> [!NOTE]
> Este guia usa comandos Linux padrão. Se você usa outra plataforma, adapte os comandos conforme necessário (ex.: `mkdir` funciona em Windows PowerShell também).

> [!TIP]
> Instale a extensão **GitHub Copilot** no VS Code para facilitar a geração de código. Você também pode usar **Continue**, **Cody** ou qualquer extensão de IA que suporte contexto de múltiplos arquivos.

---

## 🎯 O Projeto de Exemplo

Vamos criar um projeto chamado **`task-api`** — uma API REST simples para gerenciar tarefas (tasks).

Este é um projeto ideal para aprender SDD porque:
- É simples o suficiente para entender rapidamente
- Tem funcionalidades reais (CRUD de tarefas)
- Demonstra todos os componentes essenciais de um projeto SDD

---

## Passo 1 – Criar o repositório

Abra o terminal e execute:

```bash
# Crie o diretório do projeto
mkdir task-api
cd task-api

# Inicialize o Git
git init

# Crie o primeiro commit vazio (opcional, mas boa prática)
git commit --allow-empty -m "Initial commit"
```

Abra o projeto no VS Code:

```bash
code .
```

> [!TIP]
> Se o comando `code` não funcionar, abra o VS Code manualmente e use **File → Open Folder** para abrir a pasta `task-api`.

> [!NOTE]
> O Git é fundamental em projetos SDD porque você pode regenerar código sem medo — sempre pode voltar para um commit anterior se algo der errado.

---

## Passo 2 – Criar a estrutura base

Crie a estrutura mínima do projeto:

```bash
# Crie as pastas principais
mkdir -p docs/foundation docs/method spec examples

# Crie os arquivos raiz
touch README.md AGENTS.md .gitignore
```

Sua estrutura deve ficar assim:

```
task-api/
  ├── docs/               # Documentação conceitual (para humanos)
  └── spec/               # Especificações (para IA)
      └── *.spec.md       # Funcionalidades
  ├── constitution.md     # Constituição do sistema (documento fundacional)
  ├── README.md           # Visão geral do projeto
  ├── AGENTS.md           # Guardrails para IA
  └── .gitignore          # Arquivos ignorados pelo Git
```

> [!NOTE]
> A separação entre `/docs` (para humanos) e `/spec` (para IA) é fundamental no SDD. A **constitution.md** é o documento fundacional único que define a estrutura completa do sistema.

> [!TIP]
> O parâmetro `-p` do `mkdir` cria automaticamente subdiretórios aninhados, economizando comandos.

---

## Passo 3 – Criar a constituição do sistema

A constituição é o **documento fundacional único** que define todo o modelo do sistema:

```bash
touch constitution.md
```

> [!NOTE]
> A escolha da linguagem e framework é **sua**! Neste exemplo foi usado **Ruby on Rails**, mas você pode usar Python/Django, Node.js/Express, Java/Spring, Go, ou qualquer stack que preferir. O importante é declarar essa escolha na constituição.

Edite o arquivo com o seguinte conteúdo:

```markdown
# System Constitution

## 1. System Identity
- **Name**: Task API
- **Version**: 1.0.0
- **Domain**: Task Management
- **Purpose**: API REST para gerenciar tarefas de usuários

## 2. Actors
- **User**: Usuário do sistema que cria e gerencia tarefas
- **System**: Backend que processa e armazena tarefas

## 3. Core Concepts & Domain Language
- **Task**: Unidade de trabalho com título, descrição e status
- **Status**: Estados possíveis: `pending`, `in_progress`, `completed`
- **Create**: Adicionar nova tarefa ao sistema
- **Update**: Modificar tarefa existente
- **Complete**: Marcar tarefa como concluída
- **Delete**: Remover tarefa permanentemente

## 4. Technology Stack
### Runtime
- **Language**: Ruby 3.2+
- **Framework**: Ruby on Rails 7.x

### Database
- **Development**: SQLite3
- **Production**: PostgreSQL

### Testing
- **Framework**: RSpec
- **Coverage**: Minimum 80%
- **Additional**: FactoryBot for fixtures

### Code Quality
- **Linter**: RuboCop
- **Style**: Ruby Style Guide
- **Security**: Brakeman for security analysis

## 5. Architecture
### Style
- **Pattern**: REST API
- **Structure**: Layered Architecture
  - API Layer (controllers)
  - Service Layer (business logic)
  - Data Layer (persistence)

### Project Organization
```
/app
  /controllers  # HTTP endpoints
  /models       # Data models (Active Record)
  /services     # Business logic
  /views        # Views (se necessário)
/spec           # RSpec tests
/config         # Configuration
/db             # Database migrations
```

### Architectural Constraints
- No business logic in controllers
- Services must be stateless
- All errors must return standard format

## 6. Non-Functional Requirements
### Performance
- Response time < 200ms for simple operations
- Support up to 100 concurrent users

### Security
- Input sanitization mandatory
- Rate limiting: 100 requests/minute per user

### Reliability
- 99% uptime
- Graceful error handling

## 7. Business Context
Sistema simples para demonstrar SDD em ação.
Foco em CRUD básico de tarefas sem autenticação (por enquanto).
```

> [!NOTE]
> A **constituição** é o documento fundacional completo. Ela contém TUDO que define a estrutura, identidade e restrições do sistema: conceitos, stack, arquitetura e requisitos não-funcionais. As specs (`.spec.md`) vêm depois e definem apenas comportamentos funcionais específicos.

> [!TIP]
> Para projetos pequenos/médios, uma constituição única é suficiente. Para projetos grandes e complexos, você pode dividir em múltiplos arquivos (`00-constitution.md`, `00-architecture.md`, `00-nfr.md`) para facilitar manutenção, mas a abordagem unificada é recomendada para começar.

---

## Passo 4 – Criar a primeira spec comportamental

Agora sim vamos criar a primeira **spec de comportamento** — uma funcionalidade real do sistema:

```bash
touch spec/01-create-task.spec.md
```

> [!NOTE]
> Agora usamos `.spec.md` porque este arquivo define **comportamento funcional**, não conceitos ou arquitetura. O prefixo `01-` indica que é a primeira funcionalidade.

### Exemplo: 01-create-task.spec.md

```markdown
# Feature: Create Task

## Description
User can create a new task with title and description.

## Endpoint
```
POST /api/tasks
```

## Input
```json
{
  "title": string (required, 1-100 chars),
  "description": string (optional, max 500 chars)
}
```

## Processing
1. Validate input format
2. Check title is not empty
3. Generate unique task ID
4. Set status to "pending"
5. Store task
6. Return created task

## Output Success (201 Created)
```json
{
  "status": "success",
  "data": {
    "id": "uuid",
    "title": "Task title",
    "description": "Task description",
    "status": "pending",
    "createdAt": "2026-01-16T10:00:00Z"
  }
}
```

## Output Errors

### 400 INVALID_INPUT
```json
{
  "status": "error",
  "error": {
    "code": "INVALID_INPUT",
    "message": "Title is required and must be between 1-100 characters"
  }
}
```

## Test Cases
- ✅ Create task with title only
- ✅ Create task with title and description
- ❌ Create task without title (error 400)
- ❌ Create task with title > 100 chars (error 400)
```

> [!NOTE]
> Veja como a spec é **completa e precisa**. Ela define entrada, processamento, saída de sucesso, erros específicos e casos de teste. A IA não precisa adivinhar nada.

> [!TIP]
> Comece com uma funcionalidade simples (como criar uma tarefa) antes de adicionar funcionalidades complexas. Isso permite validar o processo SDD rapidamente.

### Estrutura final da pasta raiz:

```
task-api/
  ├── constitution.md             # Documento fundacional único
  ├── AGENTS.md                   # Guardrails da IA
  ├── spec/
  │   └── 01-create-task.spec.md  # Primeira funcionalidade
  ├── docs/                       # Documentação para humanos
  ├── README.md
  └── .gitignore
```

> [!TIP]
> **Convenção**: `constitution.md` contém toda a base (conceitos, stack, arquitetura, NFRs). Arquivos `spec/*.spec.md` contêm apenas funcionalidades específicas (requisitos funcionais).

---

## Passo 5 – Definir os guardrails da IA (AGENTS.md)

Agora vamos configurar o arquivo mais importante do SDD: o `AGENTS.md`. Ele define as **regras que a IA deve seguir** ao gerar código.

Edite o arquivo `AGENTS.md` na raiz do projeto:

```markdown
# AGENTS.md - AI Guardrails for Task API

## 1. REGRAS GERAIS

### 1.1 Especificação é a fonte da verdade
- A IA NUNCA deve gerar comportamento não declarado nas specs
- Se a spec estiver incompleta, retorne erro pedindo atualização da spec

### 1.2 Não inventar
- Não inferir, adivinhar ou completar regras implícitas
- Toda funcionalidade deve estar explícita na spec

### 1.3 Não modificar specs
- A IA nunca altera arquivos .spec.md
- Mudanças de comportamento requerem atualização manual das specs

## 2. ARQUITETURA

### 2.1 Estrutura obrigatória
```
/app
  /controllers  # Controllers apenas (herdam de ApplicationController)
  /models       # Active Record models
  /services     # Business logic (POROs - Plain Old Ruby Objects)
/spec           # RSpec tests
```

### 2.2 Separação de responsabilidades
- Controllers: apenas request/response handling
- Services: lógica de negócio
- Models: estruturas de dados
- NUNCA colocar lógica de negócio em controllers

## 3. PADRÕES DE CÓDIGO

### 3.1 Estilo
- Ruby Style Guide
- RuboCop obrigatório
- Todos os arquivos devem passar no lint

### 3.2 Testes obrigatórios
- RSpec como framework
- Mínimo 80% de cobertura
- Testar casos de sucesso e erro
- Testar todas as regras da spec

## 4. API

### 4.1 Formato de resposta padrão
Todas as respostas devem seguir:

```json
{
  "status": "success" | "error",
  "data": <object | null>,
  "error": {
    "code": string,
    "message": string
  }
}
```

### 4.2 Validações
- Validar todos os inputs conforme spec
- Retornar erros claros (ex: 400 INVALID_INPUT)
- Nunca permitir comportamento não especificado

## 5. SEGURANÇA

### 5.1 Autenticação
- Endpoints privados por padrão
- Apenas endpoints explicitamente marcados como públicos são públicos

### 5.2 Proteções básicas
- Sanitizar todas as entradas
- Rate limiting conforme spec
- Nunca expor detalhes internos nos erros

## 6. ERROS & LOGS

### 6.1 Erros
- Apenas erros declarados na spec podem ser retornados
- Seguir formato padrão de erro

### 6.2 Logs
- Log em operações de criação/atualização/deleção
- NUNCA logar dados sensíveis

## 7. RESTRIÇÕES

### 7.1 Não gerar features não especificadas
Se algo não está na spec:
1. Abortar a geração
2. Retornar erro
3. Pedir atualização da spec

### 7.2 Regenerabilidade
- Todo código deve poder ser completamente regenerado
- Não criar dependências de estado anterior
```

> [!NOTE]
> O `AGENTS.md` é o "contrato" entre você e a IA. Ele garante que o código gerado sempre siga seus padrões, independentemente do modelo de IA usado.

> [!TIP]
> Copie o `AGENTS.md` do SDD Starter Pack como base e adapte conforme as necessidades do seu projeto. Não precisa criar do zero.

---

## Passo 6 – Geração inicial do código

Agora vem a mágica! Vamos gerar o código a partir das especificações.

### No VS Code:

1. **Selecione os documentos essenciais**:
   - `constitution.md` (documento fundacional)
   - `AGENTS.md` (guardrails)
   - Pasta `/spec` com as specs comportamentais
2. **Abra o chat da IA** (GitHub Copilot, Continue, ou outra extensão)
3. **Envie o seguinte comando**:

```
Generate the full system following these specifications and guardrails.
Do not invent or assume behavior not defined in spec.
Return code + tests + documentation.
```

### O que esperar:

A IA deve gerar:
- ✅ Estrutura Rails completa (`/app`, `/config`, `/db`, `/spec`)
- ✅ Arquivo `Gemfile` com dependências
- ✅ Controllers em `/app/controllers`
- ✅ Services em `/app/services`
- ✅ Models em `/app/models`
- ✅ Routes em `/config/routes.rb`
- ✅ Testes RSpec em `/spec`
- ✅ Arquivo `README.md` atualizado

> [!NOTE]
> A IA pode levar alguns minutos para gerar tudo. Seja paciente. Se ela parar no meio, peça para continuar.

> [!TIP]
> Se a IA sugerir algo não especificado (ex.: adicionar autenticação não pedida), **rejeite e lembre-a das regras do AGENTS.md**. A spec é a fonte da verdade.

### Exemplo de resposta esperada:

```
Gerando sistema baseado nas especificações...

✓ Criada estrutura de diretórios Rails
✓ Gerado Gemfile com dependências
✓ Criado POST /api/tasks (controller + routes)
✓ Criados testes RSpec para create-task
✓ Configurado RuboCop

Sistema gerado com sucesso!
Para rodar: bundle install && rails db:setup && rails server
Para testar: bundle exec rspec
```

---

## Passo 7 – Validação e testes

Após a geração, **sempre valide** se o código segue as specs:

```bash
# Instale as dependências
bundle install

# Configure o banco de dados
rails db:create db:migrate

# Execute os testes
bundle exec rspec

# Execute o linter
bundle exec rubocop

# Rode o sistema
rails server
```

### Checklist de validação:

- [ ] Todos os endpoints especificados existem?
- [ ] Os formatos de entrada/saída correspondem à spec?
- [ ] Todos os erros especificados são retornados corretamente?
- [ ] Os testes cobrem os casos definidos na spec?
- [ ] O código segue a arquitetura definida?
- [ ] Não há lógica de negócio em controllers?

> [!NOTE]
> Se encontrar qualquer divergência entre código e spec, **NÃO corrija o código manualmente**. Em vez disso, atualize a spec (se necessário) e regenere o código.

### Testando a API:

```bash
# Teste criar uma tarefa
curl -X POST http://localhost:3000/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"task": {"title": "Minha primeira tarefa", "description": "Aprender SDD"}}'

# Resposta esperada (201 Created):
{
  "status": "success",
  "data": {
    "id": "uuid-gerado",
    "title": "Minha primeira tarefa",
    "description": "Aprender SDD",
    "status": "pending",
    "createdAt": "2026-01-16T10:30:00Z"
  }
}
```

> [!TIP]
> Use ferramentas como **Postman**, **Insomnia** ou **Thunder Client** (extensão do VS Code) para testar APIs de forma mais visual.

---

## Passo 8 – Commit e versionamento

Depois de validar que tudo está funcionando:

```bash
# Adicione todos os arquivos gerados
git add .

# Faça o commit
git commit -m "feat: initial system generation from specs

- Implemented POST /api/tasks (01-create-task.spec.md)
- Added architecture and stack configuration
- Generated tests with 80%+ coverage
- Configured linting and formatting"

# (Opcional) Crie uma tag de versão
git tag -a v0.1.0 -m "First working version generated via SDD"
```

> [!NOTE]
> Documente no commit quais specs foram usadas. Isso cria rastreabilidade entre especificações e código gerado.

> [!TIP]
> Sempre faça um commit após uma geração bem-sucedida. Se a próxima geração der errado, você pode voltar facilmente com `git reset --hard`.

---

## Passo 9 – Próximos passos

Agora que você tem um sistema funcionando, pode expandir:

### Adicionar novas funcionalidades:

```bash
# Crie uma nova spec
touch spec/02-list-tasks.spec.md
touch spec/03-update-task.spec.md
touch spec/04-delete-task.spec.md
```

### Processo iterativo:

1. **Escreva a nova spec** com todos os detalhes
2. **Selecione a spec + constitution.md + AGENTS.md**
3. **Peça à IA**: "Generate code for spec/02-list-tasks.spec.md following constitution and guardrails"
4. **Valide** os novos endpoints
5. **Commit** as mudanças

> [!TIP]
> Adicione uma funcionalidade por vez. Isso facilita validação e debug caso algo dê errado.

### Refatorar ou mudar stack:

Se você quiser mudar de Ruby para Python:

1. **Atualize a seção 4 do `constitution.md`**:
   ```markdown
   ## Runtime
   - **Language**: Python 3.11+
   - **Framework**: Django 5.x
   ```

2. **Delete todo o código gerado** (`rm -rf src/ tests/`)
3. **Regenere**: "Generate full system from specs"
4. **Valide** novamente

> [!NOTE]
> Esta é a mágica do SDD: você pode **regenerar tudo do zero** sempre que quiser, porque a especificação é a fonte da verdade, não o código.

---

## Regra final

> Nunca comece pelo código.
> Nunca corrija o código.
> Sempre corrija a especificação.

---

## Resultado

Você criou um projeto do zero **sem escrever código manualmente**, usando SDD.
