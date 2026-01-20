# 08a - Ver Detalhes do Produto (Product Details)

## 📋 Descrição

Usuário pode visualizar os detalhes completos de um produto específico. Quando clica em um produto na listagem, é redirecionado para uma página dedicada do produto com todas as informações e opção de adicionar ao carrinho.

## 🎯 Objetivos

- Visualizar detalhes completos de um produto
- Adicionar produto ao carrinho a partir da página de detalhes
- Modificar quantidade antes de adicionar
- Ver preço e disponibilidade

---

## 📊 Dados

### Entrada (Request)

**Ver Detalhes do Produto**
```
GET /api/products/:id
```

### Saída (Response)

**Sucesso - Get Product Details**
```json
{
  "status": "success",
  "data": {
    "id": "product-uuid-123",
    "title": "Laptop Pro",
    "description": "High-performance laptop with Intel i9 processor, 32GB RAM, 1TB SSD, 15.6 inch display. Perfect for professionals.",
    "quantity": 15,
    "price": 1299.99,
    "createdAt": "2025-01-16T10:00:00Z",
    "updatedAt": "2025-01-19T14:30:00Z"
  }
}
```

### Erros

```
404 PRODUCT_NOT_FOUND
  Mensagem: "Produto não encontrado"
  Causa: product_id não existe

400 INVALID_PRODUCT_ID
  Mensagem: "ID do produto inválido"
  Causa: ID não é UUID válido
```

---

## 🔄 Fluxo

### Fluxo de Visualização

```
User acessa /products
            ↓
Vê lista de produtos em cards
            ↓
Clica em um card
            ↓
Browser redireciona para /products/:product_id
            ↓
GET /api/products/:id (fetch dados)
            ↓
Página exibe detalhes completos:
  - Título
  - Descrição longa
  - Preço
  - Estoque (quantidade disponível)
  - Imagem (placeholder)
  - Data de criação
            ↓
User vê botões:
  [Seletor de quantidade] [Adicionar ao Carrinho]
  [◀ Voltar para Produtos]
            ↓
User modifica quantidade se quiser
            ↓
Clica "Adicionar ao Carrinho"
            ↓
POST /api/cart/items (add ao carrinho)
            ↓
Toast de sucesso: "✅ Produto adicionado ao carrinho!"
```

---

## 🔌 Endpoint

### GET /api/products/:id

**Request**
```
Method: GET
URL: /api/products/product-uuid-123
```

**Response (200)**
```json
{
  "status": "success",
  "data": {
    "id": "product-uuid-123",
    "title": "Laptop Pro",
    "description": "High-performance laptop with Intel i9 processor, 32GB RAM, 1TB SSD, 15.6 inch display. Perfect for professionals.",
    "quantity": 15,
    "price": 1299.99,
    "createdAt": "2025-01-16T10:00:00Z",
    "updatedAt": "2025-01-19T14:30:00Z"
  }
}
```

**Response (404 - PRODUCT_NOT_FOUND)**
```json
{
  "status": "error",
  "error": {
    "code": "PRODUCT_NOT_FOUND",
    "message": "Produto não encontrado"
  }
}
```

**Response (400 - INVALID_PRODUCT_ID)**
```json
{
  "status": "error",
  "error": {
    "code": "INVALID_PRODUCT_ID",
    "message": "ID do produto inválido"
  }
}
```

---

## 📱 Frontend Pages

### 1. Products Page (modificada)
```
URL: /products

Cada card clicável:
┌─────────────────────────────┐
│ Laptop Pro                  │
│ $1,299.99                   │
│ Descrição resumida...       │
│                             │
│ Em estoque: 15 unidades     │
│                             │
│ [Clique para ver detalhes] ←──┐
└─────────────────────────────┘  │
                                  │
                                  │ onclick: redireciona
                                  │
                                  ↓
                        ┌─────────────────────────────┐
                        │ /products/product-uuid      │
                        └─────────────────────────────┘
```

### 2. Product Details Page (NOVO)
```
URL: /products/:id
Exemplo: /products/abc123def456

Layout:
┌──────────────────────────────────────────┐
│ ◀ Voltar para Produtos                   │
├──────────────────────────────────────────┤
│                                          │
│ ┌──────────────┐   Laptop Pro            │
│ │              │   ★★★★★ (5.0)          │
│ │   [IMAGE]    │                        │
│ │  Placeholder │   Preço: $1,299.99     │
│ │              │   Em estoque: 15       │
│ └──────────────┘                        │
│                                          │
│ Descrição Completa:                     │
│ High-performance laptop with Intel i9   │
│ processor, 32GB RAM, 1TB SSD, 15.6      │
│ inch display. Perfect for professionals.│
│                                          │
│ Especificações:                         │
│ - Processador: Intel i9                 │
│ - Memória: 32GB RAM                     │
│ - Armazenamento: 1TB SSD                │
│ - Display: 15.6 inch                    │
│                                          │
│ Quantidade: [1 ▼]                       │
│ [➕ Adicionar ao Carrinho] [🛒 Carrinho]│
│                                          │
│ Enviado por: Admin                      │
│ Data: 16/01/2025                        │
│                                          │
│ [📞 Contato] [❓ Dúvidas] [💬 Reviews] │
└──────────────────────────────────────────┘
```

---

## ✅ Casos de Teste

### Sucesso
- [x] GET /api/products/:id com UUID válido retorna 200 + dados
- [x] Retorna todos os campos do produto
- [x] Data está em formato ISO8601
- [x] Preço está em decimal com 2 casas

### Erros
- [x] GET /api/products/:id com UUID inválido retorna 400
- [x] GET /api/products/:id com produto inexistente retorna 404
- [x] GET /api/products/invalid-string retorna 400

### Frontend
- [x] Página carrega detalhes via API ao abrir
- [x] Exibe título, descrição, preço, quantidade
- [x] Seletor de quantidade funciona (1-disponível)
- [x] Botão "Adicionar ao Carrinho" chama POST /api/cart/items
- [x] Link "Voltar" redireciona para /products
- [x] Lista de produtos tem links clicáveis para detalhes
- [x] Loading indicator enquanto carrega dados

---

## 🔐 Segurança

- ✅ Validação de UUID format
- ✅ Tratamento de 404 para produtos inexistentes
- ✅ Sem exposição de dados sensíveis
- ✅ Frontend não calcula preço

---

## 📝 Notas

1. **Sem Autenticação**: Endpoint é público (qualquer pessoa pode ver detalhes)
2. **Imagem**: Por enquanto é placeholder, pode adicionar URL depois
3. **Avaliações**: Campo "ratings" é sugestão para futuro
4. **Especificações**: Por enquanto descrição em texto, pode ser JSON depois

---

## 🔗 Relacionamentos

- **Specs Anteriores**: 04 - Listar Produtos
- **Specs Posteriores**: 08 - Shopping Cart (usa os detalhes para adicionar)
- **Componentes Reutilizados**: Product model, ProductSerializer

---

**Status**: 📋 Aguardando Validação
