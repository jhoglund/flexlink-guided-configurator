#!/usr/bin/env bash
# exit on error
set -o errexit

echo "🚀 Starting build process..."

# Install dependencies
echo "📦 Installing dependencies..."
bundle install

# Precompile assets
echo "🎨 Precompiling assets..."
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Run database migrations
echo "🗄️  Running database migrations..."
bundle exec rake db:migrate

echo "✅ Build completed successfully!" 