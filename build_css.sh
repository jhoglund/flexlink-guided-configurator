#!/bin/bash

echo "🔧 Building CSS..."

# Check if we're in Docker environment
if docker ps | grep -q "flexlink-guided-configurator-web"; then
    echo "🐳 Using Docker environment..."
    docker-compose -f docker-compose.dev.yml exec web npm run build:css:once
else
    echo "💻 Using local environment..."
    npm run build:css:once
fi

echo "✅ CSS build complete!" 