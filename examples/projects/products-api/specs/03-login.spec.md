# Feature: Login User

## Description
Registered user can authenticate with email and password to get a JWT token for accessing protected endpoints.

## Endpoint

POST /api/auth/login

## Input

~~~json
{
  "email": string (required, valid email format),
  "password": string (required)
}
~~~

## Processing
1. Validate email format
2. Find user by email
3. Compare provided password with stored hash
4. Generate JWT token (24 hours expiration) with user_id and role
5. Return user data with token
6. Log authentication attempt

## Output Success (200 OK)
~~~json
{
  "status": "success",
  "data": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "User Name",
    "role": "user",
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
    "message": "Password is required"
  }
}
~~~

### 401 UNAUTHORIZED
~~~json
{
  "status": "error",
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid email or password"
  }
}
~~~

## Test Cases
- ✅ Login with valid email and password
- ✅ JWT token is generated and returned
- ✅ Token contains user_id and role
- ✅ User data is returned with login
- ❌ Login without email (error 400)
- ❌ Login with invalid email format (error 400)
- ❌ Login without password (error 400)
- ❌ Login with non-existent email (error 401)
- ❌ Login with wrong password (error 401)
- ❌ Login with email not registered (error 401)
