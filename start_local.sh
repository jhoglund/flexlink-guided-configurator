#!/bin/bash

# Start script for local development with SQLite
echo "🚀 Starting FlexLink Guided Configurator locally with SQLite..."

# Temporarily disable .env file to avoid PostgreSQL configuration
if [ -f ".env" ]; then
  mv .env .env.disabled
  echo "🔧 Temporarily disabled .env file to use SQLite"
fi

# Set environment for development
export RAILS_ENV=development
# Don't set DATABASE_URL - let Rails use database.yml configuration

# Ensure database exists and is migrated
echo "🔧 Setting up SQLite database..."
rails db:create 2>/dev/null || true
rails db:migrate

# Check if we have a user, create one if not
echo "👤 Checking for test user..."
if ! rails runner "puts User.count" 2>/dev/null | grep -q "[1-9]"; then
  echo "📝 Creating test user..."
  rails runner "User.create!(email: 'test@example.com', password: 'password123', first_name: 'Test', last_name: 'User') unless User.exists?"
fi

# Start the Rails server
echo "📡 Starting Rails server on http://localhost:3000"
echo "🔧 Using SQLite database for local development"
echo ""
echo "💡 You can now access:"
echo "   - Home page: http://localhost:3000"
echo "   - Wizard: http://localhost:3000/wizard/step/1"
echo "   - Products: http://localhost:3000/products"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

rails server -p 3000 