#!/bin/bash

echo "🚀 Starting FlexLink Configurator..."

# Check if Docker is available and running
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    echo "🐳 Using Docker development environment..."
    ./start_dev.sh
elif command -v docker >/dev/null 2>&1; then
    echo "🐳 Docker installed but not running. Starting Docker..."
    open -a Docker
    echo "⏳ Waiting for Docker to start..."
    sleep 15
    
    if docker info >/dev/null 2>&1; then
        echo "✅ Docker started successfully. Starting development environment..."
        ./start_dev.sh
    else
        echo "❌ Docker failed to start. Falling back to local setup..."
        ./start_local.sh
    fi
else
    echo "🐳 Docker not available. Using local development setup..."
    ./start_local.sh
fi 