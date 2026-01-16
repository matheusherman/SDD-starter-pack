# Feature: Create Product

## Description
User can create a new products with title, description, quantity, and price.

## Endpoint

POST /api/products

## Input

~~~json
{
  "title": string (required, 1-100 chars),
  "description": string (optional, max 500 chars),
  "quantity": Integer (required),
  "price": number (required, positive),
}
~~~

## Processing
1. Validate input format
2. Check title is not empty
3. Generate unique product ID
5. Store product in database
6. Return created product

## Output Success (201 Created)
~~~json
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
~~~

## Output Errors

### 400 INVALID_INPUT
~~~json
{
  "status": "error",
  "error": {
    "code": "INVALID_INPUT",
    "message": "Title is required and must be between 1-100 characters"
  }
}
~~~

## Test Cases
- ✅ Create produt with, quantity and price
- ✅ Create produt with title, description, quantity and price
- ❌ Create product without title (error 400)
- ❌ Create product without quantity (error 400)
- ❌ Create product without price (error 400)
- ❌ Create product with title > 100 chars (error 400)
- ❌ Create product with quantity < 0 (error 400)
- ❌ Create product with price negative (error 400)