# Operations

## Common Commands
- Start (Docker-first): `./start.sh`
- Docker dev only: `./start_dev.sh`
- Local only: `./start_local.sh`
- Clear CSS/assets: `./dev_css.sh`
- Reset DB: `./reset_db.sh`
- Tests: `docker-compose -f docker-compose.dev.yml exec web bin/rails test`

## Services
- Sidekiq: runs in Docker `sidekiq` service
- Redis: `redis://redis:6379/0`
- Postgres: `postgresql://flexlink_user:flexlink_password@postgres:5432/flexlink_config`

## Health Checks
- Web up: http://localhost:3000
- Guard LiveReload: port 35729
- Docker: `docker-compose ps`

## Logs
- All: `docker-compose logs -f`
- Web: `docker-compose logs -f web`
- Sidekiq: `docker-compose logs -f sidekiq`

## Troubleshooting
- Ports busy: `lsof -i :3000`, `lsof -i :5432`, `lsof -i :6379`
- Asset issues: run `./dev_css.sh`
- DB reset: `./reset_db.sh`

