# SQLite Migration for Local Development

This document explains how to use SQLite for local development instead of PostgreSQL.

## Overview

The application has been configured to use SQLite for local development and testing, while keeping PostgreSQL for production. This provides a simpler setup for development without requiring Docker or PostgreSQL installation.

## Quick Start

### Option 1: Use the start script (Recommended)
```bash
./start_local.sh
```

### Option 2: Manual setup
```bash
# Reset database (if needed)
./reset_db.sh

# Start server
rails server -p 3000
```

## What Changed

### Database Configuration
- **Development/Test**: Uses SQLite (`db/development.sqlite3`, `db/test.sqlite3`)
- **Production**: Still uses PostgreSQL via `DATABASE_URL`

### Scripts Added
- `start_local.sh` - Starts the application with SQLite
- `reset_db.sh` - Resets the SQLite database

### Environment Handling
- The scripts temporarily disable the `.env` file to avoid PostgreSQL configuration conflicts
- SQLite configuration is handled by `config/database.yml`

## Benefits

1. **No Docker required** - Run locally without Docker containers
2. **No PostgreSQL installation** - SQLite is included with Rails
3. **Faster startup** - No database server startup time
4. **Simpler development** - Direct file-based database
5. **Easy reset** - Just delete the `.sqlite3` files

## Database Files

- `db/development.sqlite3` - Development database
- `db/test.sqlite3` - Test database

## Environment Variables

The following environment variables are still loaded from `.env` for Supabase integration:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

But database configuration is handled by `config/database.yml`.

## Troubleshooting

### If you get PostgreSQL connection errors:
1. Make sure you're using the provided scripts
2. Check that `.env` file is being disabled during startup
3. Verify `config/database.yml` has SQLite configuration

### If you need to reset the database:
```bash
./reset_db.sh
```

### If you want to use PostgreSQL locally:
1. Start Docker containers: `docker-compose up`
2. Use the original `.env` configuration
3. Run: `rails server -p 3000`

## Production

Production still uses PostgreSQL as configured in `docker-compose.yml` and the `.env` file. This migration only affects local development. 