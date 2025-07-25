# API Documentation

## Base URL
```
http://localhost:8080/api
```

## Authentication Endpoints

### 1. Register User
**POST** `/auth/signup`

Register a new user account.

**Request Body:**
```json
{
  "username": "testuser",
  "email": "test@example.com",
  "password": "password123",
  "role": ["user"]
}
```

**Response (Success):**
```json
{
  "message": "User registered successfully!"
}
```

**Response (Error):**
```json
{
  "message": "Error: Username is already taken!"
}
```

### 2. Login User
**POST** `/auth/signin`

Authenticate user and get JWT token.

**Request Body:**
```json
{
  "username": "testuser",
  "password": "password123"
}
```

**Response (Success):**
```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "type": "Bearer",
  "id": "507f1f77bcf86cd799439011",
  "username": "testuser",
  "email": "test@example.com",
  "roles": ["ROLE_USER"]
}
```

**Response (Error):**
```json
{
  "message": "Error: Invalid credentials!"
}
```

### 3. Logout User
**POST** `/auth/signout`

Logout user (client-side token removal).

**Headers:**
```
Authorization: Bearer <your-jwt-token>
```

**Response:**
```json
{
  "message": "You've been signed out successfully!"
}
```

## Test Endpoints

### 1. Public Content
**GET** `/test/all`

Access public content (no authentication required).

**Response:**
```
Public Content.
```

### 2. User Content
**GET** `/test/user`

Access user content (requires authentication).

**Headers:**
```
Authorization: Bearer <your-jwt-token>
```

**Response:**
```
User Content.
```

### 3. Moderator Content
**GET** `/test/mod`

Access moderator content (requires MODERATOR or ADMIN role).

**Headers:**
```
Authorization: Bearer <your-jwt-token>
```

**Response:**
```
Moderator Board.
```

### 4. Admin Content
**GET** `/test/admin`

Access admin content (requires ADMIN role).

**Headers:**
```
Authorization: Bearer <your-jwt-token>
```

**Response:**
```
Admin Board.
```

## User Roles

- **USER**: Basic user role (default)
- **MODERATOR**: Moderator role with additional permissions
- **ADMIN**: Administrator role with full permissions

## Error Responses

### 401 Unauthorized
```json
{
  "path": "/api/test/user",
  "error": "Unauthorized",
  "message": "Full authentication is required to access this resource",
  "status": 401
}
```

### 403 Forbidden
```json
{
  "path": "/api/test/admin",
  "error": "Forbidden",
  "message": "Access is denied",
  "status": 403
}
```

## Testing with cURL

### Register a new user:
```bash
curl -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123",
    "role": ["user"]
  }'
```

### Login:
```bash
curl -X POST http://localhost:8080/api/auth/signin \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "password123"
  }'
```

### Access protected endpoint:
```bash
curl -X GET http://localhost:8080/api/test/user \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE"
```

## Security Features

1. **Password Encryption**: All passwords are hashed using BCrypt
2. **JWT Tokens**: Secure token-based authentication
3. **Role-based Access Control**: Different access levels based on user roles
4. **CORS Configuration**: Cross-origin requests handling
5. **Input Validation**: Request validation using Bean Validation
6. **Security Headers**: Proper security headers configuration