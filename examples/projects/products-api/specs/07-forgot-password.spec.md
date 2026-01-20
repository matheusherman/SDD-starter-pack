# 07 - Recuperar Senha (Forgot Password)

## 📋 Descrição

Sistema de recuperação de senha para usuários que perderam acesso à sua conta. 
O usuário fornece seu email, recebe um token de reset válido por 1 hora, e pode usar esse token para definir uma nova senha.

## 🎯 Objetivos

- Permitir que usuários recuperem acesso à conta esquecida
- Gerar tokens de reset seguros e de curta duração
- Validar tokens antes de permitir reset
- Atualizar senha de forma segura

---

## 📊 Dados

### Entrada (Request)

**Forgot Password (Solicitar Reset)**
```json
{
  "email": "user@example.com"
}
```

**Reset Password (Executar Reset)**
```json
{
  "token": "abc123def456",
  "new_password": "newPassword123456"
}
```

### Saída (Response)

**Sucesso - Forgot Password**
```json
{
  "status": "success",
  "data": {
    "message": "Reset link sent to your email",
    "email": "user@example.com",
    "reset_token": "abc123def456ghi789jkl012mno345pqr",
    "token_expires_at": "2025-01-19T15:30:00Z"
  },
  "error": null
}
```

**Sucesso - Reset Password**
```json
{
  "status": "success",
  "data": {
    "message": "Password successfully reset",
    "email": "user@example.com"
  },
  "error": null
}
```

### Erros

```
400 INVALID_EMAIL
  Mensagem: "Email não encontrado no sistema"
  Causa: Email não existe na base de dados

400 INVALID_TOKEN
  Mensagem: "Token de reset inválido ou expirado"
  Causa: Token não existe, não bate com o usuário, ou expirou

400 INVALID_PASSWORD
  Mensagem: "Senha deve ter no mínimo 8 caracteres"
  Causa: Nova senha não atende requisitos

400 EXPIRED_TOKEN
  Mensagem: "Token de reset expirou"
  Causa: Token é válido mas seu tempo expirou
```

---

## 🔄 Fluxo

### Fluxo de Solicitação

```
User clica "Esqueci minha senha"
            ↓
[Página de forgot password]
            ↓
User digita email + clica "Send Reset Link"
            ↓
POST /api/auth/forgot-password
  { "email": "user@example.com" }
            ↓
Sistema verifica se email existe
            ↓
    ✓ Sim                  ✗ Não
    ↓                       ↓
Gera token               Retorna erro
Valido por 1h          400 INVALID_EMAIL
Salva em DB
    ↓
Response com token
    ↓
User recebe email com link
(ou guarda token manualmente para teste)
```

### Fluxo de Reset

```
User recebe email com link
  (contém: /reset-password?token=abc123...)
            ↓
[Clica no link]
            ↓
[Página de reset password]
Extrai token da URL
            ↓
User digita nova senha + clica "Reset Password"
            ↓
POST /api/auth/reset-password
  { 
    "token": "abc123...",
    "new_password": "newPassword123456"
  }
            ↓
Sistema valida token
            ↓
Token válido e não expirou?
    ✓ Sim                  ✗ Não
    ↓                       ↓
Valida senha            Retorna erro
    ↓                  400 INVALID_TOKEN
Senha válida?
    ✓ Sim               ✗ Não
    ↓                   ↓
Hash e salva        Retorna erro
Limpa token        400 INVALID_PASSWORD
    ↓
Response de sucesso
    ↓
Redireciona para login
```

---

## 🔐 Segurança

### Token de Reset

- ✅ Deve ser único por usuário
- ✅ Deve ser gerado aleatoriamente (32+ caracteres)
- ✅ Válido por 1 hora (3600 segundos)
- ✅ Não reutilizável após reset
- ✅ Limpo após expiração

### Senha

- ✅ Mínimo 8 caracteres
- ✅ Hash com bcrypt (mesmo padrão do cadastro)
- ✅ Não pode ser a mesma senha anterior (opcional: implementar depois)
- ✅ Limpa em memória após processamento

### Auditoria

- ✅ Log de solicitação de reset
- ✅ Log de reset bem-sucedido
- ✅ Log de tentativas falhadas

---

## 📱 Frontend Pages

### 1. Forgot Password Page
```
URL: /forgot-password

Layout:
┌─────────────────────────────────┐
│ 🔐 Recuperar Senha              │
├─────────────────────────────────┤
│ Esqueceu sua senha?             │
│ Sem problema, vamos resolver.   │
│                                 │
│ [Email do usuário]              │
│ [Enviar Link de Reset]          │
│                                 │
│ Lembraste? [Login]              │
└─────────────────────────────────┘
```

### 2. Reset Password Page
```
URL: /reset-password?token=abc123...

Layout:
┌─────────────────────────────────┐
│ 🔐 Redefinir Senha              │
├─────────────────────────────────┤
│ Crie uma nova senha             │
│                                 │
│ [Nova Senha]                    │
│ [Confirmar Senha]               │
│ [Redefinir Senha]               │
│                                 │
│ Voltar para [Login]             │
└─────────────────────────────────┘
```

---

## 🗄️ Banco de Dados

### Alterações na tabela `users`

```sql
ALTER TABLE users ADD COLUMN reset_token VARCHAR(255);
ALTER TABLE users ADD COLUMN reset_token_expires_at DATETIME;
```

### Schema

```ruby
create_table :users do |t|
  t.string :email, null: false
  t.string :name, null: false
  t.string :password_digest, null: false
  t.string :role, default: 'user'
  t.string :reset_token  # NEW
  t.datetime :reset_token_expires_at  # NEW
  t.timestamps
end
```

---

## 🔌 Endpoints

### 1. POST /api/auth/forgot-password

**Solicitar token de reset**

```
Request:
  Method: POST
  URL: /api/auth/forgot-password
  Body: {
    "email": "user@example.com"
  }

Response (200):
  {
    "status": "success",
    "data": {
      "message": "Reset link sent to your email",
      "email": "user@example.com",
      "reset_token": "abc123...",
      "token_expires_at": "2025-01-19T15:30:00Z"
    }
  }

Response (400 - INVALID_EMAIL):
  {
    "status": "error",
    "error": {
      "code": "INVALID_EMAIL",
      "message": "Email não encontrado no sistema"
    }
  }
```

### 2. POST /api/auth/reset-password

**Executar reset com token**

```
Request:
  Method: POST
  URL: /api/auth/reset-password
  Body: {
    "token": "abc123...",
    "new_password": "newPassword123456"
  }

Response (200):
  {
    "status": "success",
    "data": {
      "message": "Password successfully reset",
      "email": "user@example.com"
    }
  }

Response (400 - INVALID_TOKEN):
  {
    "status": "error",
    "error": {
      "code": "INVALID_TOKEN",
      "message": "Token de reset inválido ou expirado"
    }
  }

Response (400 - INVALID_PASSWORD):
  {
    "status": "error",
    "error": {
      "code": "INVALID_PASSWORD",
      "message": "Senha deve ter no mínimo 8 caracteres"
    }
  }

Response (400 - EXPIRED_TOKEN):
  {
    "status": "error",
    "error": {
      "code": "EXPIRED_TOKEN",
      "message": "Token de reset expirou"
    }
  }
```

---

## ✅ Casos de Teste

### Sucesso

- [x] POST /api/auth/forgot-password com email válido retorna 200 + token
- [x] POST /api/auth/reset-password com token e senha válidos retorna 200
- [x] Usuário consegue fazer login com nova senha
- [x] Token é invalidado após reset bem-sucedido

### Erros

- [x] POST /api/auth/forgot-password com email inválido retorna 400 INVALID_EMAIL
- [x] POST /api/auth/reset-password com token inválido retorna 400 INVALID_TOKEN
- [x] POST /api/auth/reset-password com token expirado retorna 400 EXPIRED_TOKEN
- [x] POST /api/auth/reset-password com senha < 8 caracteres retorna 400 INVALID_PASSWORD
- [x] POST /api/auth/reset-password com token já usado retorna 400 INVALID_TOKEN

### Validações

- [x] Email não pode estar vazio
- [x] Nova senha não pode estar vazia
- [x] Token não pode estar vazio
- [x] Token deve ter formato válido

---

## 📝 Notas Importantes

1. **Para Desenvolvimento**: Token é retornado na resposta para permitir testes sem sistema de email
2. **Para Produção**: Remover token da resposta e enviar apenas via email
3. **Expiração**: Token válido por 1 hora apenas
4. **Limpeza**: Limpar tokens expirados periodicamente (background job)
5. **Rate Limiting**: Considerar adicionar limite de tentativas no futuro

---

## 🔗 Relacionamentos

- **Specs Anteriores**: 02-cadastrar-usuario.spec.md (password handling)
- **Specs Posteriores**: Password change (user logged in)
- **Componentes Reutilizados**: JwtToken service, User model, bcrypt hashing

---

**Status**: ✅ Pronto para Implementação
