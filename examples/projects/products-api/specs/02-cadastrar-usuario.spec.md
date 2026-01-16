# Feature: Register User

## Description
Anonymous user can create a new account in the system with email, password, and name.

## Endpoint

POST /api/users

## Input

~~~json
{
  "email": string (required, valid email format),
  "password": string (required, minimum 8 characters),
  "name": string (required, 1-100 chars)
}
~~~

## Processing
1. Validate input format
2. Check email is valid and unique
3. Check password meets minimum requirements
4. Hash password with Bcrypt
5. Create user with role "user" (default)
6. Generate JWT token (24 hours expiration)
7. Store user in database
8. Return created user with token

## Output Success (201 Created)
~~~json
{
  "status": "success",
  "data": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "User Name",
    "role": "user",
    "createdAt": "2026-01-16T10:00:00Z",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
~~~

## Output Errors

### 400 INVALID_EMAIL
~~~json
{
  "status": "error",
  "error": {
    "code": "INVALID_EMAIL",
    "message": "Email is required and must be a valid email format"
  }
}
~~~

### 400 INVALID_PASSWORD
~~~json
{
  "status": "error",
  "error": {
    "code": "INVALID_PASSWORD",
    "message": "Password must be at least 8 characters"
  }
}
~~~

### 400 INVALID_NAME
~~~json
{
  "status": "error",
  "error": {
    "code": "INVALID_NAME",
    "message": "Name is required and must be between 1-100 characters"
  }
}
~~~

### 409 EMAIL_ALREADY_EXISTS
~~~json
{
  "status": "error",
  "error": {
    "code": "EMAIL_ALREADY_EXISTS",
    "message": "Email already registered"
  }
}
~~~

## Test Cases
- ✅ Register user with email, password and name
- ✅ Password is hashed before storage
- ✅ JWT token is generated and returned
- ✅ User role defaults to "user"
- ❌ Register without email (error 400)
- ❌ Register with invalid email format (error 400)
- ❌ Register without password (error 400)
- ❌ Register with password < 8 chars (error 400)
- ❌ Register without name (error 400)
- ❌ Register with name > 100 chars (error 400)
- ❌ Register with email already exists (error 409)
