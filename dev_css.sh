#!/bin/bash

echo "🔧 CSS Development Helper"
echo "=========================="

# Check if we're in Docker environment
if docker ps | grep -q "flexlink-guided-configurator-web"; then
    echo "🐳 Docker environment detected"
    
    echo "📝 Clearing old assets..."
    docker-compose -f docker-compose.dev.yml exec web bin/rails assets:clobber
    
    echo "🔄 Restarting web container..."
    docker-compose -f docker-compose.dev.yml restart web
    
    echo "✅ CSS updated! Refresh your browser."
    echo "💡 Tip: CSS changes should now auto-reload in development."
else
    echo "💻 Local environment detected"
    
    echo "📝 Clearing old assets..."
    bin/rails assets:clobber
    
    echo "✅ CSS updated! Refresh your browser."
    echo "💡 Tip: CSS changes should now auto-reload in development."
fi

echo ""
echo "🎯 For CSS development:"
echo "   1. Make your CSS changes in app/assets/stylesheets/application.css"
echo "   2. Save the file"
echo "   3. Refresh browser (changes should auto-reload)"
echo "   4. If needed, run: ./dev_css.sh"
echo "" 