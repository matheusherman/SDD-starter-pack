# Feature: Update Product

## Description
Admin user can update an existing product's details (title, description, quantity, price).

## Endpoint

PATCH /api/products/:id

## Input

~~~json
{
  "title": string (optional, 1-100 chars),
  "description": string (optional, max 500 chars),
  "quantity": integer (optional, non-negative),
  "price": number (optional, positive)
}
~~~

## Processing
1. Check user is authenticated and has admin role
2. Find product by ID
3. Validate input format
4. Update product in database
5. Return updated product

## Output Success (200 OK)
~~~json
{
  "status": "success",
  "data": {
    "id": "uuid",
    "title": "Updated title",
    "description": "Updated description",
    "quantity": 50,
    "price": 149.99,
    "createdAt": "2026-01-16T10:00:00Z",
    "updatedAt": "2026-01-16T11:00:00Z"
  }
}
~~~

## Output Errors

### 401 UNAUTHORIZED
~~~json
{
  "status": "error",
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Authentication required"
  }
}
~~~

### 403 FORBIDDEN
~~~json
{
  "status": "error",
  "error": {
    "code": "FORBIDDEN",
    "message": "Only admin can update products"
  }
}
~~~

### 404 NOT_FOUND
~~~json
{
  "status": "error",
  "error": {
    "code": "NOT_FOUND",
    "message": "Product not found"
  }
}
~~~

### 400 INVALID_INPUT
~~~json
{
  "status": "error",
  "error": {
    "code": "INVALID_INPUT",
    "message": "Invalid field value"
  }
}
~~~

## Test Cases
- ✅ Update product with admin token
- ✅ Update partial fields (only title, only price, etc)
- ✅ Update all fields
- ✅ updatedAt timestamp is refreshed
- ❌ Update without authentication (error 401)
- ❌ Update with normal user role (error 403)
- ❌ Update non-existent product (error 404)
- ❌ Update with invalid title length (error 400)
- ❌ Update with negative quantity (error 400)
- ❌ Update with zero or negative price (error 400)
