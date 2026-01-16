# Feature: Delete Product

## Description
Admin user can permanently delete a product from the system.

## Endpoint

DELETE /api/products/:id

## Input
None

## Processing
1. Check user is authenticated and has admin role
2. Find product by ID
3. Delete product from database
4. Return success response

## Output Success (200 OK)
~~~json
{
  "status": "success",
  "data": {
    "id": "uuid",
    "message": "Product deleted successfully"
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
    "message": "Only admin can delete products"
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

## Test Cases
- ✅ Delete product with admin token
- ✅ Product is removed from database
- ✅ Returns success response with product id
- ❌ Delete without authentication (error 401)
- ❌ Delete with normal user role (error 403)
- ❌ Delete non-existent product (error 404)
- ❌ Deleted product cannot be retrieved
