#!/bin/bash

# Reset SQLite database for local development
echo "🔄 Resetting SQLite database for local development..."

# Temporarily disable .env file to avoid PostgreSQL configuration
if [ -f ".env" ]; then
  mv .env .env.disabled
  echo "🔧 Temporarily disabled .env file to use SQLite"
fi

# Set environment for development
export RAILS_ENV=development
# Don't set DATABASE_URL - let Rails use database.yml configuration

# Remove existing database files
echo "🗑️  Removing existing database files..."
rm -f db/development.sqlite3
rm -f db/test.sqlite3

# Create and migrate database
echo "🔧 Creating new database..."
rails db:create
rails db:migrate

# Create test user
echo "👤 Creating test user..."
rails runner "User.create!(email: 'test@example.com', password: 'password123', first_name: 'Test', last_name: 'User') unless User.exists?"

echo "✅ Database reset complete!"
echo "💡 You can now run: ./start_local.sh" 