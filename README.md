# Spring Boot JWT Authentication with MongoDB Atlas

A complete Spring Boot application with JWT-based authentication using MongoDB Atlas as the database.

## Features

- User Registration
- User Login with JWT token generation
- User Logout
- Role-based access control (USER, ADMIN, MODERATOR)
- MongoDB Atlas integration
- Password encryption using BCrypt
- Token-based authentication with JWT
- RESTful API endpoints

## Technologies Used

- Java 17
- Spring Boot 3.2.0
- Spring Security
- Spring Data MongoDB
- JWT (JSON Web Tokens)
- MongoDB Atlas
- Maven

## Prerequisites

- Java 17 or higher
- Maven 3.6+
- MongoDB Atlas account and cluster

## Setup Instructions

### 1. MongoDB Atlas Configuration

1. Create a MongoDB Atlas account at https://www.mongodb.com/cloud/atlas
2. Create a new cluster
3. Create a database user with read/write permissions
4. Get your connection string from the "Connect" button in your cluster

### 2. Application Configuration

Update the `src/main/resources/application.properties` file with your MongoDB Atlas credentials:

```properties
# Replace <username>, <password>, <cluster-url>, and <database-name> with your actual values
spring.data.mongodb.uri=mongodb+srv://<username>:<password>@<cluster-url>/<database-name>?retryWrites=true&w=majority
spring.data.mongodb.database=authdb

# JWT Configuration (you can change the secret key)
app.jwtSecret=mySecretKey
app.jwtExpirationMs=86400000

# Server Configuration
server.port=8080
```

### 3. Build and Run

```bash
# Build the application
mvn clean compile

# Run the application
mvn spring-boot:run
```

The application will start on `http://localhost:8080`

## API Endpoints

### Authentication Endpoints

#### Register a new user
```http
POST /api/auth/signup
Content-Type: application/json

{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "password123",
  "role": ["user"]
}
```

#### Login
```http
POST /api/auth/signin
Content-Type: application/json

{
  "username": "john_doe",
  "password": "password123"
}
```

Response:
```json
{
  "accessToken": "eyJhbGciOiJIUzUxMiJ9...",
  "tokenType": "Bearer",
  "id": "64a1b2c3d4e5f6789012345",
  "username": "john_doe",
  "email": "john@example.com",
  "roles": ["ROLE_USER"]
}
```

#### Logout
```http
POST /api/auth/signout
Authorization: Bearer <your_jwt_token>
```

### Test Endpoints

#### Public endpoint (no authentication required)
```http
GET /api/test/all
```

#### User endpoint (requires USER, MODERATOR, or ADMIN role)
```http
GET /api/test/user
Authorization: Bearer <your_jwt_token>
```

#### Moderator endpoint (requires MODERATOR role)
```http
GET /api/test/mod
Authorization: Bearer <your_jwt_token>
```

#### Admin endpoint (requires ADMIN role)
```http
GET /api/test/admin
Authorization: Bearer <your_jwt_token>
```

## User Roles

- `user` - Basic user role
- `mod` - Moderator role
- `admin` - Administrator role

If no role is specified during registration, the user is assigned the `USER` role by default.

## Testing with cURL

### Register a new user:
```bash
curl -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123"
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

## Project Structure

```
src/
├── main/
│   ├── java/com/example/authapp/
│   │   ├── controller/           # REST controllers
│   │   ├── dto/                  # Data Transfer Objects
│   │   ├── model/                # Entity models
│   │   ├── repository/           # Data repositories
│   │   ├── security/             # Security configuration
│   │   │   ├── jwt/              # JWT utilities
│   │   │   └── services/         # Security services
│   │   └── AuthAppApplication.java
│   └── resources/
│       └── application.properties
└── test/
```

## Security Features

- Password encryption using BCrypt
- JWT tokens for stateless authentication
- Role-based access control
- CORS configuration for cross-origin requests
- Custom authentication entry point for unauthorized access

## Convenience Scripts

### Starting the Application
```bash
./run.sh
```
This script will:
- Check if `application.properties` exists
- Offer to create it from the sample if it doesn't exist
- Start the Spring Boot application

### Testing the API
```bash
./test-api.sh
```
This script will:
- Test all authentication endpoints
- Demonstrate the complete registration → login → access protected resources flow
- Verify JWT token functionality

## Additional Files

- `API_DOCUMENTATION.md` - Comprehensive API documentation with examples
- `application-sample.properties` - Template configuration file
- `run.sh` - Convenience script to start the application
- `test-api.sh` - Automated API testing script

## Notes

- JWT tokens expire after 24 hours (configurable)
- The application uses stateless authentication (no sessions)
- MongoDB Atlas automatically handles scaling and backups
- All passwords are encrypted before storing in the database
- The application compiles successfully with Java 17+ and Maven
- Contains deprecation warnings for Spring Security which are expected in newer versions

## Quick Start Summary

1. **Setup MongoDB Atlas** and get your connection string
2. **Configure** the database connection in `application.properties`
3. **Start** the application with `./run.sh`
4. **Test** the API with `./test-api.sh`
5. **Build** for production with `mvn clean package`

Your Spring Boot JWT authentication application is now ready for use! 🚀