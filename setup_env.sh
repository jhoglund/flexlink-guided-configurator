#!/bin/bash

# Setup script for FlexLink Guided Configurator
# This script creates the .env file with the correct Supabase configuration

echo "Setting up environment variables for FlexLink Guided Configurator..."

# Create .env file
cat > .env << 'EOF'
# Supabase Configuration (from PDF extractor project)
SUPABASE_URL=https://vpgawhkvfibhzafkdcsa.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZwZ2F3aGt2ZmliaHphZmtkY3NhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM3Nzk0NjAsImV4cCI6MjA2OTM1NTQ2MH0.QjGdS6_Y4Dkud1E2wGBI11UE1UXljvMW5v0FQm1tJmc

# Rails Configuration
RAILS_ENV=development
RAILS_MASTER_KEY=your_master_key_here

# Database Configuration (for local PostgreSQL in Docker)
DATABASE_URL=postgresql://flexlink_user:flexlink_password@postgres:5432/flexlink_config

# Redis Configuration (for local Redis in Docker)
REDIS_URL=redis://redis:6379/0

# Application Configuration
APP_HOST=localhost
APP_PORT=3000

# Development Settings
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true
EOF

echo "✅ Created .env file with Supabase configuration"
echo ""
echo "📋 Environment variables set:"
echo "   - SUPABASE_URL: https://vpgawhkvfibhzafkdcsa.supabase.co"
echo "   - SUPABASE_ANON_KEY: [configured]"
echo "   - DATABASE_URL: postgresql://flexlink_user:flexlink_password@postgres:5432/flexlink_config"
echo "   - REDIS_URL: redis://redis:6379/0"
echo ""
echo "🚀 You can now start the application with:"
echo "   docker-compose up --build"
echo ""
echo "⚠️  Note: You may need to generate a RAILS_MASTER_KEY for production use." 