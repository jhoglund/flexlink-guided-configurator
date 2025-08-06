#!/bin/bash

echo "🚀 Starting FlexLink Configurator in development mode with auto-reload..."

# Stop any existing containers
docker-compose down

# Start the development environment
docker-compose -f docker-compose.dev.yml up --build

echo "✅ Development environment started!"
echo "📱 Open http://localhost:3000 in your browser"
echo "🔄 Auto-reload is enabled - changes will automatically refresh the browser" 