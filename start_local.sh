#!/bin/bash

# Start script for local development without Docker
echo "🚀 Starting FlexLink Guided Configurator locally..."

# Temporarily disable DATABASE_URL to use SQLite
export DATABASE_URL=""

# Start the Rails server
echo "📡 Starting Rails server on http://localhost:3000"
echo "🔧 Using SQLite database for local development"
echo ""
echo "💡 You can now access:"
echo "   - Home page: http://localhost:3000"
echo "   - Wizard: http://localhost:3000/wizard/step/1"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

rails server -p 3000 