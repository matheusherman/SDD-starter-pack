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
~~~
/app
  /controllers  # Controllers apenas (herdam de ApplicationController)
  /models       # Active Record models
  /services     # Business logic (POROs - Plain Old Ruby Objects)
  /views        # JSON views (Jbuilder ou similar)
/spec           # RSpec tests
~~~

### 2.2 Separação de responsabilidades
- Controllers: apenas request/response handling
- Services: lógica de negócio
- Models: estruturas de dados
- Views: formatação de resposta
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

~~~json
{
  "status": "success" | "error",
  "data": <object | null>,
  "error": {
    "code": string,
    "message": string
  }
}
~~~

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