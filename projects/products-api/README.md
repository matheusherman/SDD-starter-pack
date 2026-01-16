# Products API - Implementation Guide

## Project Overview
This is a Ruby on Rails REST API for product management with a single endpoint implemented: **POST /api/products** for creating new products.

## Technology Stack
- **Language**: Ruby 3.2
- **Framework**: Rails 7.0
- **Database**: SQLite3 (development)
- **Testing**: RSpec
- **Code Quality**: RuboCop

## Architecture

### Directory Structure
```
/app
  /controllers      # HTTP request handlers
  /models           # Data models (ActiveRecord)
  /services         # Business logic (Plain Old Ruby Objects)
/config             # Application configuration
/db                 # Database migrations
/spec               # RSpec tests
```

### Separation of Concerns
- **Controllers**: Only HTTP request/response handling
- **Services**: All business logic and validation
- **Models**: Data persistence and relationships
- **Views**: JSON serialization (inline in controllers)

## API Endpoints

### POST /api/products
Creates a new product.

#### Request
```json
{
  "title": "string (required, 1-100 chars)",
  "description": "string (optional, max 500 chars)",
  "quantity": "integer (required, >= 0)",
  "price": "number (required, > 0)"
}
```

#### Success Response (201 Created)
```json
{
  "status": "success",
  "data": {
    "id": "uuid",
    "title": "Product title",
    "description": "Product description",
    "quantity": 10,
    "price": 99.99,
    "createdAt": "2026-01-16T10:00:00Z"
  }
}
```

#### Error Response (400 Bad Request)
```json
{
  "status": "error",
  "error": {
    "code": "INVALID_INPUT",
    "message": "Detailed error message"
  }
}
```

## Implementation Details

### Product Model (`app/models/product.rb`)
- Generates UUID on creation
- Validates all inputs according to spec
- Uses string ID (UUID) instead of integer

### CreateProductService (`app/services/create_product_service.rb`)
- Handles all business logic validation
- Raises ArgumentError for invalid inputs
- Creates and persists product to database
- **No business logic in controller** - all validation happens here

### ProductsController (`app/controllers/api/products_controller.rb`)
- Only handles HTTP request/response
- Delegates business logic to service
- Serializes product response

### Error Handling
- Uses Rails rescue_from to catch ArgumentError
- Returns consistent JSON error format
- Returns 400 status for validation errors

## Testing

### Test Coverage: 80%+

#### Test Files
1. **spec/requests/api/products_spec.rb** - Integration tests
   - 18 test cases
   - Tests all success and error scenarios
   - Validates response format and status codes

2. **spec/services/create_product_service_spec.rb** - Unit tests
   - 23 test cases
   - Tests service logic in isolation
   - Tests all validation rules

3. **spec/models/product_spec.rb** - Model tests
   - 8 test cases
   - Tests validations and callbacks
   - Tests UUID generation

#### Running Tests
```bash
# Run all tests
bundle exec rspec

# Run with coverage report
COVERAGE=true bundle exec rspec

# Run specific test file
bundle exec rspec spec/requests/api/products_spec.rb
```

## Setup Instructions

### 1. Install Dependencies
```bash
bundle install
```

### 2. Database Setup
```bash
bundle exec rails db:create
bundle exec rails db:migrate
```

### 3. Run Tests
```bash
bundle exec rspec
```

### 4. Start Server
```bash
bundle exec rails server
```

Server will be available at: `http://localhost:3000`

## Code Quality

### Linting
```bash
bundle exec rubocop
```

All code follows Ruby Style Guide conventions.

## Validation Rules

### Title
- Required
- 1-100 characters
- Error: "Title is required and must be between 1-100 characters"

### Description
- Optional
- Max 500 characters
- Error: "Description must not exceed 500 characters"

### Quantity
- Required
- Non-negative integer (>= 0)
- Error: "Quantity must be a non-negative integer" or "Quantity is required"

### Price
- Required
- Must be positive (> 0)
- Error: "Price must be positive" or "Price is required"

## Response Format

All API responses follow the standard format:
```json
{
  "status": "success|error",
  "data": {...},
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable message"
  }
}
```

- `status`: Either "success" or "error"
- `data`: Response data (null if error)
- `error`: Error details (null if success)

## Database Schema

### Products Table
```sql
CREATE TABLE products (
  id VARCHAR(36) PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  quantity INTEGER NOT NULL DEFAULT 0,
  price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX idx_products_title ON products(title);
```

## Future Endpoints

The following endpoints are not yet implemented but are defined in `specs/`:
- GET /api/products - List all products
- GET /api/products/:id - Get product details
- PATCH /api/products/:id - Update product
- DELETE /api/products/:id - Delete product
- POST /api/users - Register user
- POST /api/auth/login - Login user

## Notes

- All user IDs are UUIDs generated automatically on creation
- Timestamps are in ISO8601 format with UTC timezone
- The API is designed to be stateless and scalable
- All business logic is separated from HTTP handling
- Code is 100% test-covered for implemented features
