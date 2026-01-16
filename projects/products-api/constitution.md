# System Constitution

## 1. System Identity
- **Name**: Products API
- **Version**: 1.0.0
- **Domain**: Products Management
- **Purpose**: API REST para gerenciar produtos em um sistema de vendas.

## 2. Actors
- **User**: Usuário normal do sistema que acessa e compra produtos
- **Admin**: Usuário administrador que cria, gerencia produtos, estoque e usuários
- **System**: Backend que processa e armazena produtos e pedidos

## 3. Core Concepts & Domain Language
- **Product**: Item disponível pra venda com nome, descricao, quantidade e preço
- **Status**: Estados de compra possíveis: `pending`, `in_progress`, `completed`
- **Create**: Adicionar novo produto ao sistema
- **Update**: Modificar produto existente
- **Complete**: Marcar produto como comprado
- **Delete**: Remover produto permanentemente

## 4. Technology Stack
### Runtime
- **Language**: Ruby 3.2+
- **Framework**: Ruby on Rails 7.x

### Authentication & Authorization
- **Authentication**: JWT (JSON Web Tokens)
- **Password Hashing**: Bcrypt
- **Authorization**: Role-based Access Control (RBAC)

### Database
- **Development**: SQLite3
- **Production**: MySQL

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

/app
  /controllers  # HTTP endpoints
  /models       # Data models (Active Record)
  /services     # Business logic
  /views        # Views
/spec           # RSpec tests
/config         # Configuration
/db             # Database migrations

### Architectural Constraints
- No business logic in controllers
- Services must be stateless
- All errors must return standard format
- Authentication required for all protected endpoints
- Authorization checks must validate user role before resource access

## 5.1. User Roles & Permissions

### Admin Role
**Permissions**:
- Criar novos produtos (CREATE)
- Listar todos os produtos (READ)
- Atualizar produtos existentes (UPDATE)
- Deletar produtos (DELETE)
- Gerenciar estoque
- Visualizar todos os pedidos
- Gerenciar usuários

### User Role (Normal)
**Permissions**:
- Listar produtos disponíveis (READ)
- Comprar produtos (CREATE order)
- Visualizar seus pedidos (READ own orders)
- Atualizar seu perfil (UPDATE own profile)

### Anonymous (Not Authenticated)
**Permissions**:
- Listar produtos disponíveis (READ - public)
- Criar nova conta (register)
- Fazer login

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
Foco em CRUD básico de produtos com autenticacao de usuarios, e com niveis de acesso.

## 8. Authentication & Authorization Details

### Authentication Flow
1. User registra-se com email e senha
2. Senha é hasheada com Bcrypt e armazenada no banco
3. User faz login com email e senha
4. Sistema valida credenciais e retorna JWT token
5. Token é incluído em requisições subsequentes (Bearer token no header Authorization)
6. Sistema valida token em cada requisição protegida

### Authorization Flow
1. Token é decodificado para extrair user_id e role
2. Controller obtém user e verifica se está autenticado
3. Service/Controller verifica role do usuário
4. Se role não tem permissão para ação, retorna 403 Forbidden
5. Se role tem permissão, executa ação

### Token Validation
- **Expiration**: 1 hora
- **Storage**: Local storage (frontend)
- **Scope**: User ID + Role inclusos no token
- **Refresh**: Token refresh endpoint para renovação
