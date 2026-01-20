# 08 - Checkout & Shopping Cart

## 📋 Descrição

Sistema de carrinho de compras e checkout. Usuários podem adicionar múltiplos produtos ao carrinho, modificar quantidades e preços, e depois executar a compra, gerando um pedido (order).

## 🎯 Objetivos

- Permitir que usuários selecionem múltiplos produtos
- Manter um carrinho persistente por usuário
- Permitir modificação de quantidades e remoção
- Executar compra com validação de estoque
- Gerar pedidos com histórico

---

## 📊 Dados

### Entrada (Request)

**Adicionar Item ao Carrinho**
```json
{
  "product_id": "uuid-123",
  "quantity": 2
}
```

**Atualizar Item do Carrinho**
```json
{
  "quantity": 5
}
```

**Executar Compra**
```json
{
  "shipping_address": "Rua X, 123, São Paulo, SP",
  "payment_method": "credit_card"
}
```

### Saída (Response)

**Sucesso - Adicionar ao Carrinho**
```json
{
  "status": "success",
  "data": {
    "message": "Product added to cart",
    "cart": {
      "id": "cart-uuid",
      "user_id": "user-uuid",
      "items": [
        {
          "id": "item-uuid",
          "product_id": "product-uuid",
          "product_title": "Laptop Pro",
          "quantity": 2,
          "unit_price": 1299.99,
          "total_price": 2599.98
        }
      ],
      "total_items": 2,
      "total_price": 2599.98,
      "created_at": "2025-01-19T12:00:00Z",
      "updated_at": "2025-01-19T12:30:00Z"
    }
  }
}
```

**Sucesso - Listar Carrinho**
```json
{
  "status": "success",
  "data": {
    "id": "cart-uuid",
    "user_id": "user-uuid",
    "items": [
      {
        "id": "item-uuid",
        "product_id": "product-uuid",
        "product_title": "Laptop Pro",
        "quantity": 2,
        "unit_price": 1299.99,
        "total_price": 2599.98
      }
    ],
    "total_items": 2,
    "total_price": 2599.98,
    "created_at": "2025-01-19T12:00:00Z",
    "updated_at": "2025-01-19T12:30:00Z"
  }
}
```

**Sucesso - Checkout**
```json
{
  "status": "success",
  "data": {
    "message": "Order created successfully",
    "order": {
      "id": "order-uuid",
      "user_id": "user-uuid",
      "order_number": "ORD-20250119-001",
      "status": "confirmed",
      "items": [
        {
          "product_id": "product-uuid",
          "product_title": "Laptop Pro",
          "quantity": 2,
          "unit_price": 1299.99,
          "subtotal": 2599.98
        }
      ],
      "subtotal": 2599.98,
      "tax": 519.99,
      "total": 3119.97,
      "shipping_address": "Rua X, 123, São Paulo, SP",
      "payment_method": "credit_card",
      "created_at": "2025-01-19T12:35:00Z"
    }
  }
}
```

### Erros

```
400 INVALID_PRODUCT_ID
  Mensagem: "Produto não encontrado"
  Causa: product_id não existe

400 INVALID_QUANTITY
  Mensagem: "Quantidade deve ser no mínimo 1"
  Causa: quantity < 1

400 OUT_OF_STOCK
  Mensagem: "Produto sem estoque"
  Causa: quantity > product.quantity

401 UNAUTHORIZED
  Mensagem: "Você precisa estar autenticado"
  Causa: Token JWT inválido ou ausente

400 EMPTY_CART
  Mensagem: "Carrinho vazio"
  Causa: Tentando fazer checkout sem itens

400 INVALID_SHIPPING_ADDRESS
  Mensagem: "Endereço é obrigatório"
  Causa: shipping_address vazio

400 INVALID_PAYMENT_METHOD
  Mensagem: "Método de pagamento inválido"
  Causa: payment_method não suportado
```

---

## 🔄 Fluxo

### Fluxo de Compra Completo

```
User está em /products
           ↓
Vê um produto: "Laptop Pro"
Clica em [Adicionar ao Carrinho]
           ↓
POST /api/cart/items
  { product_id: "abc123", quantity: 2 }
           ↓
✓ Produto adicionado
Carrinho agora tem 1 item (2 unidades)
           ↓
Continua vendo produtos
Adiciona mais produtos...
           ↓
Clica em [Ver Carrinho]
GET /api/cart
           ↓
Vê todos os itens, totais
Pode modificar quantidades
           ↓
Clica em [Checkout]
Vai para página /checkout
           ↓
Preenche endereço de entrega
Escolhe método de pagamento
Clica em [Confirmar Compra]
           ↓
POST /api/orders
  {
    shipping_address: "Rua X...",
    payment_method: "credit_card"
  }
           ↓
✓ Pedido criado
Order ID: ORD-20250119-001
           ↓
Redireciona para /order-confirmation/:order_id
           ↓
User vê confirmação de compra
Pode ver histórico em /orders (Orders page)
```

### Diagrama de Estados do Carrinho

```
┌─────────────┐
│ Cart Vazio  │
└──────┬──────┘
       │ Adiciona produto
       ↓
┌──────────────────┐
│ Cart com Itens   │ ← User pode adicionar/remover/modificar
│ (persistente)    │
└──────┬───────────┘
       │ Remove todos itens
       ↓ ou Completa compra
┌──────────────────┐
│ Checkout         │ ← Preenche dados de envio
└──────┬───────────┘
       │ Valida endereço, pagamento
       ↓
┌──────────────────┐
│ Order Criada     │
│ (Carrinho vazio) │
└──────────────────┘
```

---

## 🗄️ Banco de Dados

### Nova Tabela: `carts`
```ruby
create_table :carts, id: :string, primary_key: :id do |t|
  t.string :user_id, null: false
  t.datetime :created_at, null: false
  t.datetime :updated_at, null: false
  
  t.foreign_key :users
  t.index :user_id, unique: true  # Uma cart por user
end
```

### Nova Tabela: `cart_items`
```ruby
create_table :cart_items, id: :string, primary_key: :id do |t|
  t.string :cart_id, null: false
  t.string :product_id, null: false
  t.integer :quantity, default: 1, null: false
  t.decimal :unit_price, precision: 10, scale: 2
  t.datetime :created_at, null: false
  t.datetime :updated_at, null: false
  
  t.foreign_key :carts
  t.foreign_key :products
  t.index [:cart_id, :product_id], unique: true  # Um item por produto no carrinho
end
```

### Nova Tabela: `orders`
```ruby
create_table :orders, id: :string, primary_key: :id do |t|
  t.string :user_id, null: false
  t.string :order_number, null: false  # ORD-20250119-001
  t.string :status, default: 'confirmed'  # confirmed, shipped, delivered, cancelled
  t.decimal :subtotal, precision: 10, scale: 2
  t.decimal :tax, precision: 10, scale: 2
  t.decimal :total, precision: 10, scale: 2
  t.string :shipping_address, null: false
  t.string :payment_method, null: false
  t.datetime :created_at, null: false
  t.datetime :updated_at, null: false
  
  t.foreign_key :users
  t.index :user_id
  t.index :order_number, unique: true
end
```

### Nova Tabela: `order_items`
```ruby
create_table :order_items, id: :string, primary_key: :id do |t|
  t.string :order_id, null: false
  t.string :product_id, null: false
  t.string :product_title, null: false
  t.integer :quantity, null: false
  t.decimal :unit_price, precision: 10, scale: 2
  t.decimal :subtotal, precision: 10, scale: 2
  t.datetime :created_at, null: false
  
  t.foreign_key :orders
  t.foreign_key :products
end
```

---

## 🔌 Endpoints

### 1. POST /api/cart/items (Adicionar ao Carrinho)

```
Request:
  Method: POST
  URL: /api/cart/items
  Headers: Authorization: Bearer {token}
  Body: {
    "product_id": "abc123",
    "quantity": 2
  }

Response (200):
  {
    "status": "success",
    "data": {
      "message": "Product added to cart",
      "cart": {
        "id": "cart-uuid",
        "items": [...],
        "total_items": 2,
        "total_price": 2599.98
      }
    }
  }

Response (400 - INVALID_PRODUCT_ID):
  {
    "status": "error",
    "error": {
      "code": "INVALID_PRODUCT_ID",
      "message": "Produto não encontrado"
    }
  }

Response (400 - OUT_OF_STOCK):
  {
    "status": "error",
    "error": {
      "code": "OUT_OF_STOCK",
      "message": "Produto sem estoque"
    }
  }
```

### 2. GET /api/cart (Listar Carrinho)

```
Request:
  Method: GET
  URL: /api/cart
  Headers: Authorization: Bearer {token}

Response (200):
  {
    "status": "success",
    "data": {
      "id": "cart-uuid",
      "items": [...],
      "total_items": 2,
      "total_price": 2599.98
    }
  }

Response (401 - UNAUTHORIZED):
  {
    "status": "error",
    "error": {
      "code": "UNAUTHORIZED",
      "message": "Você precisa estar autenticado"
    }
  }
```

### 3. PATCH /api/cart/items/:id (Atualizar Item)

```
Request:
  Method: PATCH
  URL: /api/cart/items/item-uuid
  Headers: Authorization: Bearer {token}
  Body: { "quantity": 5 }

Response (200):
  {
    "status": "success",
    "data": {
      "message": "Cart item updated",
      "cart": {...}
    }
  }

Response (400 - INVALID_QUANTITY):
  {
    "status": "error",
    "error": {
      "code": "INVALID_QUANTITY",
      "message": "Quantidade deve ser no mínimo 1"
    }
  }
```

### 4. DELETE /api/cart/items/:id (Remover Item)

```
Request:
  Method: DELETE
  URL: /api/cart/items/item-uuid
  Headers: Authorization: Bearer {token}

Response (200):
  {
    "status": "success",
    "data": {
      "message": "Item removed from cart",
      "cart": {...}
    }
  }
```

### 5. DELETE /api/cart (Limpar Carrinho)

```
Request:
  Method: DELETE
  URL: /api/cart
  Headers: Authorization: Bearer {token}

Response (200):
  {
    "status": "success",
    "data": {
      "message": "Cart cleared"
    }
  }
```

### 6. POST /api/orders (Criar Pedido - Checkout)

```
Request:
  Method: POST
  URL: /api/orders
  Headers: Authorization: Bearer {token}
  Body: {
    "shipping_address": "Rua X, 123, São Paulo, SP",
    "payment_method": "credit_card"
  }

Response (200):
  {
    "status": "success",
    "data": {
      "message": "Order created successfully",
      "order": {
        "id": "order-uuid",
        "order_number": "ORD-20250119-001",
        "status": "confirmed",
        "items": [...],
        "total": 3119.97
      }
    }
  }

Response (400 - EMPTY_CART):
  {
    "status": "error",
    "error": {
      "code": "EMPTY_CART",
      "message": "Carrinho vazio"
    }
  }

Response (400 - OUT_OF_STOCK):
  {
    "status": "error",
    "error": {
      "code": "OUT_OF_STOCK",
      "message": "Um ou mais produtos não têm estoque suficiente"
    }
  }
```

### 7. GET /api/orders (Listar Pedidos do Usuário)

```
Request:
  Method: GET
  URL: /api/orders
  Headers: Authorization: Bearer {token}

Response (200):
  {
    "status": "success",
    "data": {
      "orders": [
        {
          "id": "order-uuid",
          "order_number": "ORD-20250119-001",
          "status": "confirmed",
          "total": 3119.97,
          "created_at": "2025-01-19T12:35:00Z"
        }
      ]
    }
  }
```

### 8. GET /api/orders/:id (Detalhes do Pedido)

```
Request:
  Method: GET
  URL: /api/orders/order-uuid
  Headers: Authorization: Bearer {token}

Response (200):
  {
    "status": "success",
    "data": {
      "id": "order-uuid",
      "order_number": "ORD-20250119-001",
      "status": "confirmed",
      "items": [...],
      "total": 3119.97,
      "shipping_address": "Rua X, 123, São Paulo, SP",
      "created_at": "2025-01-19T12:35:00Z"
    }
  }
```

---

## 📱 Frontend Pages

### 1. Products Page (com botão Adicionar ao Carrinho)
```
http://localhost:8080/products

Cada card de produto terá:
┌─────────────────────────────┐
│ Laptop Pro                  │
│ $1,299.99                   │
│ Descrição do produto        │
│                             │
│ Quantidade: [1▼]            │
│ [➕ Adicionar ao Carrinho]   │
└─────────────────────────────┘

Badge no navbar: 🛒 Carrinho (2)
```

### 2. Shopping Cart Page
```
URL: /cart

┌─────────────────────────────────────────┐
│ 🛒 Shopping Cart                        │
├─────────────────────────────────────────┤
│ Itens: 2                                │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ Laptop Pro           $1,299.99      │ │
│ │ Quantidade: [2 ▼]  [➖]  [➕]       │ │
│ │ Total: $2,599.98                    │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ Mouse Wireless       $29.99         │ │
│ │ Quantidade: [1 ▼]  [➖]  [➕]       │ │
│ │ Total: $29.99                       │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ Subtotal: $2,629.97                     │
│ Tax (20%): $525.99                      │
│ ───────────────────                     │
│ Total: $3,155.96                        │
│                                         │
│ [🔄 Continuar Comprando] [💳 Checkout] │
└─────────────────────────────────────────┘
```

### 3. Checkout Page
```
URL: /checkout

┌─────────────────────────────────────────┐
│ 💳 Checkout                             │
├─────────────────────────────────────────┤
│                                         │
│ Resumo do Pedido:                       │
│ ┌─────────────────────────────────────┐ │
│ │ 2x Laptop Pro      $2,599.98        │ │
│ │ 1x Mouse Wireless  $29.99           │ │
│ │ ─────────────────────────────────   │ │
│ │ Subtotal:          $2,629.97        │ │
│ │ Tax (20%):         $525.99          │ │
│ │ TOTAL:             $3,155.96        │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ Endereço de Entrega:                    │
│ [Rua, número, complemento]              │
│ [Cidade, Estado, CEP]                   │
│                                         │
│ Método de Pagamento:                    │
│ ○ Credit Card  ○ Debit  ○ Boleto       │
│                                         │
│ ☐ Aceito os Termos e Condições         │
│                                         │
│ [💳 Confirmar Compra]  [◀ Voltar]      │
└─────────────────────────────────────────┘
```

### 4. Order Confirmation Page
```
URL: /order-confirmation/:order_id

┌─────────────────────────────────────────┐
│ ✅ Compra Confirmada!                   │
├─────────────────────────────────────────┤
│                                         │
│ Obrigado por sua compra!                │
│ Número do pedido: ORD-20250119-001      │
│                                         │
│ Itens:                                  │
│ - 2x Laptop Pro          $2,599.98      │
│ - 1x Mouse Wireless      $29.99         │
│                                         │
│ Total: $3,155.96                        │
│                                         │
│ Endereço de Entrega:                    │
│ Rua X, 123, São Paulo, SP               │
│                                         │
│ Status: 📦 Confirmado                   │
│ Data: 19/01/2025 12:35                  │
│                                         │
│ 📧 Você receberá atualizações por email │
│                                         │
│ [📋 Ver Meus Pedidos] [🏠 Voltar Home]  │
└─────────────────────────────────────────┘
```

### 5. Orders History Page
```
URL: /orders

┌─────────────────────────────────────────┐
│ 📦 Meus Pedidos                         │
├─────────────────────────────────────────┤
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ ORD-20250119-001                    │ │
│ │ Data: 19/01/2025                    │ │
│ │ Status: 📦 Confirmado               │ │
│ │ Total: $3,155.96                    │ │
│ │ [📖 Ver Detalhes] [🔁 Repetir]      │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ ORD-20250115-001                    │ │
│ │ Data: 15/01/2025                    │ │
│ │ Status: 🚚 Enviado                  │ │
│ │ Total: $1,299.99                    │ │
│ │ [📖 Ver Detalhes]                   │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ [🛍️ Continuar Comprando]                │
└─────────────────────────────────────────┘
```

---

## ✅ Casos de Teste

### Adicionar ao Carrinho
- [x] POST /api/cart/items com product_id e quantity válidos
- [x] Produto é adicionado ao carrinho do usuário
- [x] Se produto já existe, aumenta a quantidade
- [x] Carrinho é criado automaticamente se não existir
- [x] Retorna erro se product_id inválido
- [x] Retorna erro se quantity < 1
- [x] Retorna erro se quantidade > estoque disponível

### Listar Carrinho
- [x] GET /api/cart retorna carrinho vazio se sem itens
- [x] GET /api/cart retorna todos os itens
- [x] Calcula total corretamente
- [x] Retorna erro se não autenticado

### Atualizar Carrinho
- [x] PATCH /api/cart/items/:id atualiza quantidade
- [x] DELETE /api/cart/items/:id remove item
- [x] DELETE /api/cart limpa todos os itens
- [x] Atualiza totais corretamente

### Checkout
- [x] POST /api/orders com dados válidos cria order
- [x] Gera order_number único (ORD-YYYYMMDD-NNN)
- [x] Cria order_items com dados dos produtos
- [x] Calcula tax como 20% do subtotal
- [x] Limpa o carrinho após compra bem-sucedida
- [x] Retorna erro se carrinho vazio
- [x] Retorna erro se endereço vazio
- [x] Retorna erro se payment_method inválido
- [x] Retorna erro se estoque mudou (concorrência)

### Histórico de Pedidos
- [x] GET /api/orders retorna apenas pedidos do usuário
- [x] GET /api/orders/:id retorna detalhes do pedido
- [x] Retorna erro se pedido não pertence ao usuário

---

## 🔐 Segurança

### Autenticação
- ✅ Todos os endpoints requerem JWT token válido
- ✅ Carrinho é isolado por usuário
- ✅ User não pode ver carrinho/pedidos de outro user

### Validações
- ✅ Validação de estoque em tempo real
- ✅ Validação de endereço (mínimo 10 caracteres)
- ✅ Validação de payment_method (whitelist)
- ✅ Preço é capturado do servidor (não confiável do client)

### Cálculos
- ✅ Preço unitário é recalculado do produto (não do client)
- ✅ Tax é calculado no servidor (não aceita do client)
- ✅ Total é recalculado (não aceita do client)

---

## 📝 Notas Importantes

1. **Tax**: 20% do subtotal (pode ser configurado depois)
2. **Payment Method**: Valores válidos: `credit_card`, `debit_card`, `boleto` (pode expandir)
3. **Order Number**: Formato `ORD-YYYYMMDD-NNN` (incremento diário)
4. **Stock**: Decrementado na criação da order, não na adição ao carrinho
5. **Cart Persistence**: Carrinho persiste até que order seja criada ou user limpe
6. **Concorrência**: Se estoque mudar, validar novamente no checkout

---

## 🔗 Relacionamentos

- **Specs Anteriores**: 01-04 (Produtos, Usuários, Autenticação)
- **Specs Posteriores**: 09 - Payment Processing, 10 - Shipping
- **Componentes Reutilizados**: JWT Auth, Product model, User model

---

**Status**: 📋 Aguardando Validação
