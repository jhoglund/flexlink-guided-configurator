#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for database to be ready
until pg_isready -h postgres -U flexlink_user -d flexlink_config; do
  echo "Waiting for postgres..."
  sleep 2
done

# Run database migrations
bundle exec rails db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@" 