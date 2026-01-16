# Feature: List Products

## Description
Any user (authenticated or anonymous) can list all available products in the system.

## Endpoint

GET /api/products

## Input
Query parameters (optional):
- `page`: integer (default 1)
- `limit`: integer (default 10, max 100)
- `sort`: string (default "created_at", options: "name", "price", "created_at")
- `order`: string (default "desc", options: "asc", "desc")

## Processing
1. Retrieve products from database
2. Apply pagination
3. Apply sorting
4. Return products with metadata

## Output Success (200 OK)
~~~json
{
  "status": "success",
  "data": [
    {
      "id": "uuid",
      "title": "Product title",
      "description": "Product description",
      "quantity": 10,
      "price": 99.99,
      "createdAt": "2026-01-16T10:00:00Z"
    }
  ],
  "meta": {
    "total": 100,
    "page": 1,
    "limit": 10,
    "totalPages": 10
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
    "message": "Invalid page or limit"
  }
}
~~~

## Test Cases
- ✅ List all products with default pagination
- ✅ List products with custom page and limit
- ✅ List products sorted by price ascending
- ✅ List products sorted by created_at descending
- ✅ Returns empty list when no products exist
- ✅ Returns paginated metadata
- ✅ Limit cannot exceed 100
- ❌ Invalid page returns 400
- ❌ Invalid limit returns 400
- ❌ Invalid sort parameter returns 400
