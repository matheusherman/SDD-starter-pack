# Lab 1 – Build your first SDD system

Neste laboratório você vai construir um sistema funcional **sem escrever código manualmente**, usando apenas especificações como fonte da verdade.

O objetivo é vivenciar o fluxo SDD completo: **especificar → gerar → validar → iterar**.

---

## O que você vai construir

Um sistema simples de pedidos com:

* API REST para criar e gerenciar pedidos
* Regra de preço com desconto e imposto
* Fluxo de estados do pedido (criação → pagamento → envio → entrega)

Tudo definido apenas por especificação.

### Resultado esperado

Ao final deste lab, você terá:
- Uma API REST funcional rodando localmente
- Endpoints para criar pedidos e calcular totais
- Sistema de regras que aplica descontos e impostos automaticamente
- Máquina de estados que controla o ciclo de vida dos pedidos
- Código gerado automaticamente a partir das suas especificações

---

## Pré-requisitos

Antes de começar, certifique-se de ter:

* Um editor de texto (VS Code, Vim, etc.)
* Uma IA de código disponível (Claude, GPT-4, etc.)
* Node.js ou Python instalado (dependendo da stack que será gerada)
* Git instalado (opcional, mas recomendado)

---

## Estrutura de diretórios

Você criará a seguinte estrutura:

```
/seu-projeto/
  /spec/
    00-general-context.spec.md
    01-create-order.spec.md
    02-pricing.spec.md
    03-order-flow.spec.md
  /src/ (gerado automaticamente)
  /tests/ (gerado automaticamente)
  README.md
```

---

## Arquitetura alvo

| Componente  | Função            | O que será gerado                    |
| ----------- | ----------------- | ------------------------------------ |
| API         | Criar pedidos     | Endpoints REST (Express/FastAPI)     |
| Rule Engine | Calcular total    | Funções de cálculo de preço          |
| Flow Engine | Controlar estados | Máquina de estados do pedido         |
| Storage     | Persistir pedidos | Banco de dados ou arquivo JSON       |

---

## Passo 1 – Criar o contexto do sistema

### O que você está fazendo

Está definindo o contexto geral do sistema. Este arquivo estabelece o domínio, os atores envolvidos e o propósito principal. É como criar a "capa" do seu projeto.

### Ação

Crie o diretório `/spec` e dentro dele o arquivo `00-general-context.spec.md`:

```markdown
System: Simple Shop
Domain: Orders
Purpose: Demonstrate SDD fundamentals

Actors:
  - Customer
  - System

Primary Use Case:
  Customer creates an order and receives calculated total.
```

### O que você terá

Um arquivo de especificação que define:
- **System**: Nome do sistema (Simple Shop)
- **Domain**: Área de negócio (Orders - Pedidos)
- **Actors**: Quem interage com o sistema (Cliente e o próprio Sistema)
- **Primary Use Case**: O caso de uso principal

### Verificação

✅ Arquivo criado em `/spec/00-general-context.spec.md`  
✅ Conteúdo copiado corretamente

---

## Passo 2 – Especificar a API

### O que você está fazendo

Está definindo o contrato da API REST que permitirá criar pedidos. Esta especificação define exatamente como o cliente vai interagir com o sistema.

### Ação

Crie `/spec/01-create-order.spec.md`:

```markdown
Endpoint: POST /api/orders

Input:
  items: array<{ productId: string, quantity: number }>
  customerType: REGULAR | PREMIUM

Output:
  orderId: string
  total: number

Rules:
  Quantity must be >= 1
```

### O que você terá

Uma especificação de API que define:
- **Endpoint**: Rota HTTP e método (POST /api/orders)
- **Input**: Estrutura de dados de entrada
  - `items`: Array de itens do pedido (produto e quantidade)
  - `customerType`: Tipo de cliente (REGULAR ou PREMIUM)
- **Output**: Estrutura de resposta
  - `orderId`: Identificador único do pedido
  - `total`: Valor total calculado
- **Rules**: Regras de validação (quantidade mínima)

### Exemplo de uso esperado

Quando o sistema estiver rodando, você poderá fazer uma requisição como:

```bash
curl -X POST http://localhost:3000/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "items": [
      {"productId": "prod-001", "quantity": 2},
      {"productId": "prod-002", "quantity": 1}
    ],
    "customerType": "PREMIUM"
  }'
```

E receberá uma resposta como:

```json
{
  "orderId": "order-12345",
  "total": 108.00
}
```

### Verificação

✅ Arquivo criado em `/spec/01-create-order.spec.md`  
✅ Especificação completa com input, output e regras

---

## Passo 3 – Especificar a regra de preço

### O que você está fazendo

Está definindo a lógica de negócio para cálculo de preços. Esta regra será executada automaticamente quando um pedido for criado, aplicando descontos e impostos conforme o tipo de cliente.

### Ação

Crie `/spec/02-pricing.spec.md`:

```markdown
Rule: Order pricing

Given:
  subtotal = sum(items.quantity * item_price)
  customerType = REGULAR | PREMIUM

Then:
  if customerType == PREMIUM:
      discount = subtotal * 0.10
  else:
      discount = 0

  tax = (subtotal - discount) * 0.08
  total = subtotal - discount + tax
```

### O que você terá

Uma regra de negócio que:
- Calcula o subtotal somando quantidade × preço de cada item
- Aplica desconto de 10% para clientes PREMIUM
- Calcula imposto de 8% sobre o valor após desconto
- Retorna o total final

### Exemplo de cálculo

**Cenário 1 - Cliente REGULAR:**
- Subtotal: R$ 100,00
- Desconto: R$ 0,00 (0%)
- Imposto: R$ 8,00 (8% de R$ 100)
- **Total: R$ 108,00**

**Cenário 2 - Cliente PREMIUM:**
- Subtotal: R$ 100,00
- Desconto: R$ 10,00 (10% de R$ 100)
- Imposto: R$ 7,20 (8% de R$ 90)
- **Total: R$ 97,20**

### Verificação

✅ Arquivo criado em `/spec/02-pricing.spec.md`  
✅ Lógica de desconto e imposto definida claramente

---

## Passo 4 – Especificar o fluxo

### O que você está fazendo

Está definindo a máquina de estados que controla o ciclo de vida do pedido. Esta especificação garante que as transições de estado sejam válidas e consistentes.

### Ação

Crie `/spec/03-order-flow.spec.md`:

```markdown
Flow: Order lifecycle

States: CREATED, PAID, SHIPPED, DELIVERED, CANCELLED

Transitions:
  CREATED -> PAID
  PAID -> SHIPPED
  SHIPPED -> DELIVERED
  CREATED -> CANCELLED

Rules:
  SHIPPED cannot be CANCELLED
```

### O que você terá

Uma máquina de estados que define:
- **Estados possíveis**: CREATED, PAID, SHIPPED, DELIVERED, CANCELLED
- **Transições válidas**:
  - CREATED → PAID (pedido foi pago)
  - PAID → SHIPPED (pedido foi enviado)
  - SHIPPED → DELIVERED (pedido foi entregue)
  - CREATED → CANCELLED (pedido foi cancelado antes do pagamento)
- **Regras de negócio**: Pedidos já enviados não podem ser cancelados

### Diagrama de estados

```
CREATED ──→ PAID ──→ SHIPPED ──→ DELIVERED
   │
   └──→ CANCELLED
```

### Exemplo de uso esperado

Quando o sistema estiver rodando, você poderá:
1. Criar um pedido (estado: CREATED)
2. Marcar como pago (estado: PAID)
3. Marcar como enviado (estado: SHIPPED)
4. Marcar como entregue (estado: DELIVERED)

Ou cancelar antes do pagamento:
1. Criar um pedido (estado: CREATED)
2. Cancelar (estado: CANCELLED)

**Tentativa inválida** (será bloqueada):
- Tentar cancelar um pedido no estado SHIPPED → ❌ Erro

### Verificação

✅ Arquivo criado em `/spec/03-order-flow.spec.md`  
✅ Todos os estados e transições definidos

---

## Passo 5 – Geração por IA

### O que você está fazendo

Agora você vai usar uma IA de código para gerar todo o sistema automaticamente a partir das especificações que criou. Este é o momento mágico do SDD: transformar especificações em código funcional.

### Preparação

Antes de solicitar a geração, certifique-se de ter:
- ✅ Todos os 4 arquivos de spec criados em `/spec`
- ✅ Estrutura de diretórios organizada

### Ação

1. Abra sua IA de código preferida (Claude, GPT-4, Cursor, etc.)

2. Forneça todos os arquivos de especificação:
   - `/spec/00-general-context.spec.md`
   - `/spec/01-create-order.spec.md`
   - `/spec/02-pricing.spec.md`
   - `/spec/03-order-flow.spec.md`

3. Se houver um arquivo `AGENTS.md` no projeto, inclua-o também (ele pode conter instruções sobre como gerar o código)

4. Solicite a geração com o seguinte prompt:

> "Generate the full system following these specifications. Include:
> - REST API endpoints
> - Pricing rule implementation
> - State machine for order flow
> - Data storage (can use in-memory or JSON file)
> - Basic error handling
> - README with setup instructions"

### O que você terá

A IA gerará uma estrutura completa de projeto, incluindo:

**Estrutura esperada:**
```
/seu-projeto/
  /src/
    /api/
      orders.js (ou orders.py)
    /rules/
      pricing.js (ou pricing.py)
    /flows/
      orderFlow.js (ou orderFlow.py)
    /storage/
      orders.js (ou orders.py)
  /tests/
    orders.test.js (ou orders.test.py)
  package.json (ou requirements.txt)
  README.md
  .gitignore
```

**Código gerado incluirá:**
- ✅ Servidor HTTP (Express.js, FastAPI, etc.)
- ✅ Endpoint POST /api/orders
- ✅ Função de cálculo de preço com desconto e imposto
- ✅ Máquina de estados para controle de fluxo
- ✅ Validações de entrada
- ✅ Tratamento de erros básico
- ✅ Instruções de instalação e execução

### Verificação

✅ Código gerado pela IA  
✅ Estrutura de diretórios criada  
✅ Arquivos de configuração presentes (package.json, requirements.txt, etc.)  
✅ README com instruções de setup

---

## Passo 6 – Validação

### O que você está fazendo

Agora você vai testar o sistema gerado para garantir que ele funciona exatamente como especificado. Esta é a fase de validação do SDD.

### Setup do ambiente

1. **Instale as dependências:**
   ```bash
   # Se for Node.js
   npm install
   
   # Se for Python
   pip install -r requirements.txt
   ```

2. **Inicie o servidor:**
   ```bash
   # Node.js
   npm start
   # ou
   node src/index.js
   
   # Python
   python src/main.py
   # ou
   python -m uvicorn src.main:app --reload
   ```

### Testes manuais

#### Teste 1: Criar pedido (Cliente REGULAR)

**Requisição:**
```bash
curl -X POST http://localhost:3000/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "items": [
      {"productId": "prod-001", "quantity": 2}
    ],
    "customerType": "REGULAR"
  }'
```

**Resultado esperado:**
- ✅ Status 200 ou 201
- ✅ Resposta contém `orderId` e `total`
- ✅ Total calculado corretamente (sem desconto, com imposto de 8%)

#### Teste 2: Criar pedido (Cliente PREMIUM)

**Requisição:**
```bash
curl -X POST http://localhost:3000/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "items": [
      {"productId": "prod-001", "quantity": 2}
    ],
    "customerType": "PREMIUM"
  }'
```

**Resultado esperado:**
- ✅ Status 200 ou 201
- ✅ Total calculado com desconto de 10%
- ✅ Imposto aplicado sobre o valor após desconto

#### Teste 3: Validação de quantidade

**Requisição:**
```bash
curl -X POST http://localhost:3000/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "items": [
      {"productId": "prod-001", "quantity": 0}
    ],
    "customerType": "REGULAR"
  }'
```

**Resultado esperado:**
- ✅ Status 400 (Bad Request)
- ✅ Mensagem de erro sobre quantidade inválida

#### Teste 4: Transições de estado

Teste se as transições de estado funcionam corretamente:

1. Criar pedido → estado CREATED
2. Marcar como pago → estado PAID
3. Marcar como enviado → estado SHIPPED
4. Marcar como entregue → estado DELIVERED

**Resultado esperado:**
- ✅ Cada transição funciona corretamente
- ✅ Tentar transição inválida (ex: SHIPPED → CANCELLED) retorna erro

### Checklist de validação

Marque cada item conforme testa:

- [ ] Endpoint POST /api/orders existe e responde
- [ ] Cálculo de preço funciona para cliente REGULAR
- [ ] Cálculo de preço funciona para cliente PREMIUM (com desconto)
- [ ] Imposto de 8% é aplicado corretamente
- [ ] Validação de quantidade >= 1 funciona
- [ ] Estados do pedido são controlados corretamente
- [ ] Transições válidas funcionam
- [ ] Transições inválidas são bloqueadas
- [ ] Erros são retornados de forma clara

### O que você terá

Após a validação, você terá:
- ✅ Sistema funcionando conforme especificado
- ✅ Confiança de que as specs foram interpretadas corretamente
- ✅ Base sólida para iterações futuras

---

## Passo 7 – Iteração

### O que você está fazendo

Agora você vai experimentar o poder do SDD: fazer mudanças no sistema **alterando apenas as especificações**, sem tocar no código gerado. A IA gerará o código novamente com as mudanças.

### Cenário de mudança

Vamos alterar a taxa de imposto de 8% para 12%.

### Ação

1. **Edite apenas a spec:**
   
   Abra `/spec/02-pricing.spec.md` e altere:
   
   ```markdown
   tax = (subtotal - discount) * 0.08
   ```
   
   Para:
   
   ```markdown
   tax = (subtotal - discount) * 0.12
   ```

2. **Regenere o código:**
   
   Forneça a spec atualizada para a IA e peça:
   
   > "Regenerate the pricing rule with the updated tax rate of 12%"

3. **Compare o resultado:**
   
   - Verifique que apenas a função de cálculo de preço mudou
   - Teste novamente com os mesmos dados do Passo 6
   - Confirme que o imposto agora é 12%

### Exemplo de comparação

**Antes (8%):**
- Subtotal: R$ 100,00
- Desconto: R$ 10,00 (PREMIUM)
- Imposto: R$ 7,20 (8% de R$ 90)
- **Total: R$ 97,20**

**Depois (12%):**
- Subtotal: R$ 100,00
- Desconto: R$ 10,00 (PREMIUM)
- Imposto: R$ 10,80 (12% de R$ 90)
- **Total: R$ 100,80**

### O que você acabou de fazer

Você acabou de **refatorar o sistema sem tocar no código manualmente**. 

Isso demonstra o poder do SDD:
- ✅ Mudança de regra de negócio = alterar apenas a spec
- ✅ Código regenerado automaticamente
- ✅ Menos chance de erros manuais
- ✅ Especificação sempre sincronizada com o código

### Outras iterações possíveis

Experimente fazer outras mudanças:

1. **Adicionar novo tipo de cliente:**
   - Edite `01-create-order.spec.md` e adicione `VIP` ao `customerType`
   - Edite `02-pricing.spec.md` e adicione regra para VIP (ex: 15% de desconto)
   - Regenere e teste

2. **Adicionar novo estado:**
   - Edite `03-order-flow.spec.md` e adicione estado `REFUNDED`
   - Adicione transição `DELIVERED -> REFUNDED`
   - Regenere e teste

3. **Adicionar validação:**
   - Edite `01-create-order.spec.md` e adicione regra: "Maximum 10 items per order"
   - Regenere e teste

### Verificação

✅ Spec alterada  
✅ Código regenerado  
✅ Sistema testado com nova regra  
✅ Resultado confere com a especificação atualizada

---

## Resultado

### O que você construiu

Você construiu seu primeiro sistema SDD completo, incluindo:

- ✅ **API REST funcional** para criar pedidos
- ✅ **Sistema de regras** que calcula preços automaticamente
- ✅ **Máquina de estados** que controla o ciclo de vida dos pedidos
- ✅ **Validações** que garantem dados consistentes
- ✅ **Base para iterações** futuras

### O que você aprendeu

- ✅ Como estruturar especificações SDD
- ✅ Como gerar código a partir de specs
- ✅ Como validar o sistema gerado
- ✅ Como iterar alterando apenas as especificações

### Conceito-chave

**Você não implementou — você projetou.**

No SDD, você:
- Define **o quê** o sistema deve fazer (especificações)
- Deixa a IA gerar **como** fazer (código)
- Valida que o resultado está correto
- Itera mudando apenas as specs

### Próximos passos

Agora que você entendeu o fluxo básico, você pode:

1. Explorar outros tipos de especificações (UI, integrações, etc.)
2. Adicionar mais complexidade ao sistema
3. Integrar com bancos de dados reais
4. Adicionar autenticação e autorização
5. Criar testes automatizados baseados em specs

---

## Resumo do fluxo SDD

```
1. Especificar → Criar arquivos .spec.md
2. Gerar → Usar IA para criar código
3. Validar → Testar se funciona conforme specs
4. Iterar → Alterar specs e regenerar
```

---

## Próximo Lab

Quando estiver pronto para o próximo desafio:

`/labs/lab-2-migrate-artesanal`

No Lab 2, você aprenderá a migrar um sistema existente (código artesanal) para o formato SDD.
