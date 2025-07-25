#!/bin/bash

echo "Starting Spring Boot Authentication Application..."
echo "Make sure you have configured your MongoDB Atlas connection in application.properties"
echo ""

# Check if application.properties exists
if [ ! -f "src/main/resources/application.properties" ]; then
    echo "⚠️  Warning: application.properties not found!"
    echo "Please copy application-sample.properties to application.properties"
    echo "and configure your MongoDB Atlas connection string."
    echo ""
    echo "Do you want to create a basic application.properties file? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        cp src/main/resources/application-sample.properties src/main/resources/application.properties
        echo "✅ Created application.properties from sample file"
        echo "Please edit src/main/resources/application.properties with your MongoDB Atlas details"
        exit 1
    else
        echo "❌ Cannot start without application.properties"
        exit 1
    fi
fi

echo "🚀 Starting the application..."
mvn spring-boot:run