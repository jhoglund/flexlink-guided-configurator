#!/bin/bash

echo "🚀 Starting FlexLink Configurator in development mode with auto-reload..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Starting Docker..."
    open -a Docker
    echo "⏳ Waiting for Docker to start..."
    sleep 10
fi

# Stop any existing containers
docker-compose down

# Start the development environment
docker-compose -f docker-compose.dev.yml up --build

echo "✅ Development environment started!"
echo "📱 Open http://localhost:3000 in your browser"
echo "🔄 Auto-reload is enabled - changes will automatically refresh the browser" 