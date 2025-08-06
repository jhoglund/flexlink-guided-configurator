#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Compile Tailwind CSS to ensure it's always available
echo "Compiling Tailwind CSS..."
npx tailwindcss -c tailwind.config.js -i ./app/assets/stylesheets/application.css -o ./app/assets/builds/application.css --minify

# Copy compiled CSS to public assets directory
echo "Copying CSS to public assets..."
mkdir -p ./public/assets
cp -f ./app/assets/builds/application.css ./public/assets/application.css

# Precompile Rails assets
echo "Precompiling Rails assets..."
bin/rails assets:precompile

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@" 