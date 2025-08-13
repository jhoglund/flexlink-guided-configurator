# Environment Variables

Required in development/production. Never commit secrets.

## Core
- RAILS_MASTER_KEY: Rails credentials decryption key (production only)
- DATABASE_URL: Postgres connection URL (set by Docker/Render in prod)
- REDIS_URL: Redis connection URL (set by Docker/Render in prod)

## Supabase
- SUPABASE_URL: Supabase project URL
- SUPABASE_ANON_KEY: Supabase anonymous key (read-only)

## Local (Docker dev)
- DATABASE_URL: `postgresql://flexlink_user:flexlink_password@postgres:5432/flexlink_config`
- REDIS_URL: `redis://redis:6379/0`

## Where used
- `config/database.yml` reads DATABASE_URL
- Redis/Sidekiq use REDIS_URL
- `SupabaseService` reads SUPABASE_URL and SUPABASE_ANON_KEY

## Setting in Render
Add to Web Service > Environment:
- RAILS_MASTER_KEY
- SUPABASE_URL
- SUPABASE_ANON_KEY

Automatically set by `render.yaml`:
- DATABASE_URL
- REDIS_URL
- RAILS_ENV=production
- RAILS_LOG_TO_STDOUT=true
- RAILS_SERVE_STATIC_FILES=true

