#!/bin/bash

BASE_URL="http://localhost:8080/api"

echo "🧪 Testing Spring Boot JWT Authentication API"
echo "=============================================="
echo

# Test public endpoint
echo "1. Testing public endpoint..."
curl -s -w "\nStatus: %{http_code}\n" "${BASE_URL}/test/all"
echo

# Test user registration
echo "2. Testing user registration..."
curl -s -X POST "${BASE_URL}/auth/signup" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123",
    "role": ["user"]
  }' \
  -w "\nStatus: %{http_code}\n"
echo

# Test user login
echo "3. Testing user login..."
LOGIN_RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/signin" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "password123"
  }')

echo "$LOGIN_RESPONSE"

# Extract JWT token from response (if successful)
TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ ! -z "$TOKEN" ]; then
    echo "Token extracted: ${TOKEN:0:50}..."
    echo
    
    # Test protected endpoint
    echo "4. Testing protected user endpoint..."
    curl -s -X GET "${BASE_URL}/test/user" \
      -H "Authorization: Bearer $TOKEN" \
      -w "\nStatus: %{http_code}\n"
    echo
    
    # Test admin endpoint (should fail)
    echo "5. Testing admin endpoint (should fail)..."
    curl -s -X GET "${BASE_URL}/test/admin" \
      -H "Authorization: Bearer $TOKEN" \
      -w "\nStatus: %{http_code}\n"
    echo
    
    # Test logout
    echo "6. Testing logout..."
    curl -s -X POST "${BASE_URL}/auth/signout" \
      -H "Authorization: Bearer $TOKEN" \
      -w "\nStatus: %{http_code}\n"
    echo
else
    echo "❌ Could not extract token from login response"
    echo "Please check if the application is running and MongoDB is connected"
fi

echo "✅ API testing completed!"
echo
echo "Note: Make sure to:"
echo "1. Start the application: ./run.sh"
echo "2. Configure MongoDB Atlas connection in application.properties"