# FlexLink Guided Configuration Tool - Setup Guide

## 🏗️ Architecture Overview

Single-repo Rails application with Docker containerization. Supabase provides product/catalog data (read-only). Local PostgreSQL stores application/user data. Redis supports caching and background jobs.

### Database Strategy
- **Supabase (Remote)**: Component specifications and catalog data
- **Local PostgreSQL**: Application logic, user sessions, configurations
- **Redis**: Caching and background job processing

## 🐳 Docker-First Development

### Prerequisites
- Docker and Docker Compose installed
- Git for version control
- Your existing Supabase credentials

### Quick Start

1. **Clone the Rails repository**
```bash
git clone https://github.com/jhoglund/flexlink-guided-configuration-tool.git
cd flexlink-guided-configuration-tool
```

2. **Set up environment variables**
```bash
cp env.example .env
# Edit .env with your Supabase credentials
# ⚠️ Never commit .env file to version control
```

3. **Start the development environment**
```bash
docker-compose up --build
```

4. **Access the application**
- Rails app: http://localhost:3000
- PostgreSQL: localhost:5432
- Redis: localhost:6379

## 🔧 Development Workflow

### Database Management
```bash
# Run migrations
docker-compose exec web rails db:migrate

# Reset database
docker-compose exec web rails db:reset

# Access PostgreSQL console
docker-compose exec postgres psql -U flexlink_user -d flexlink_config
```

### Rails Console
```bash
# Access Rails console
docker-compose exec web rails console
```

### Logs and Debugging
```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f web
docker-compose logs -f postgres
docker-compose logs -f sidekiq
```

## 🗄️ Database Architecture

### Supabase (Remote)
- **Purpose**: Component specifications and catalog data
- **Access**: Read-only from Rails app via `SupabaseService`

### Local PostgreSQL
- **Purpose**: Application logic and user data
- **Tables**: 
  - `users` - User accounts and sessions
  - `configurations` - Saved system configurations
  - `wizard_sessions` - Guided configuration progress
  - `component_selections` - User component choices
  - `optimization_results` - System optimization data

### Redis
- **Purpose**: Caching and background jobs
- **Usage**: Session storage, job queues, component cache

## 🚀 Deployment Options

### Free Hosting Alternatives

#### 1. **Railway** (Recommended)
- **Pros**: Free tier, PostgreSQL included, easy deployment
- **Cons**: Limited resources on free tier
- **Setup**: Connect GitHub repo, auto-deploy

#### 2. **Render**
- **Pros**: Free tier, PostgreSQL included, good performance
- **Cons**: Sleeps after 15 minutes of inactivity
- **Setup**: Connect GitHub repo, configure environment

#### 3. **Heroku** (Limited Free)
- **Pros**: Excellent Rails support, add-ons ecosystem
- **Cons**: No free PostgreSQL, requires credit card
- **Setup**: Heroku CLI, PostgreSQL add-on

#### 4. **Fly.io**
- **Pros**: Free tier, global deployment, PostgreSQL
- **Cons**: More complex setup
- **Setup**: Docker deployment, managed PostgreSQL

### Recommended Stack for Team Collaboration

#### Development
- **Local**: Docker Compose for consistent environment
- **Version Control**: GitHub with branch protection
- **Code Review**: GitHub Pull Requests
- **CI/CD**: GitHub Actions

#### Production
- **Hosting**: Railway or Render (free tier)
- **Database**: Railway PostgreSQL or Render PostgreSQL
- **Monitoring**: Free tier services (UptimeRobot, etc.)
- **Backup**: Automated database backups

## 🔄 Data Flow
1. Rails reads product data from Supabase (read-only)
2. App/user data persists to local PostgreSQL
3. Caching and background jobs use Redis/Sidekiq
4. 8-step wizard progress stored in `wizard_sessions`

## 🛠️ Development Commands

### Docker Operations
```bash
# Start all services
docker-compose up

# Start in background
docker-compose up -d

# Stop all services
docker-compose down

# Rebuild containers
docker-compose up --build

# View running containers
docker-compose ps
```

### Rails Operations
```bash
# Generate new model
docker-compose exec web rails generate model Configuration name:string

# Run tests
docker-compose exec web rails test

# Install new gems
docker-compose exec web bundle add devise

# Database operations
docker-compose exec web rails db:migrate
docker-compose exec web rails db:seed
```

### Database Operations
```bash
# Backup local database
docker-compose exec postgres pg_dump -U flexlink_user flexlink_config > backup.sql

# Restore database
docker-compose exec -T postgres psql -U flexlink_user flexlink_config < backup.sql

# Reset database
docker-compose exec web rails db:drop db:create db:migrate db:seed
```

## 🔐 Security Considerations

### Environment Variables
- Never commit `.env` files (already in `.gitignore`)
- Use different credentials for dev/staging/prod
- Rotate Supabase keys regularly
- Store Rails master key securely (`config/master.key`)
- Use environment variables for all sensitive data

### Database Security
- Local PostgreSQL: Development only
- Supabase: Production data with proper access controls
- Redis: No sensitive data, session storage only

### Team Access
- GitHub: Repository access control
- Supabase: Read-only access for team members
- Deployment: Separate staging/production environments

## 📊 Monitoring and Maintenance

### Health Checks
- Database connectivity
- Supabase API availability
- Background job processing
- Application response times

### Backup Strategy
- Daily automated backups
- Weekly manual verification
- Monthly disaster recovery test

### Performance Optimization
- Redis caching for component data
- Database query optimization
- Asset compression and CDN
- Background job processing

## 🎯 Next Steps

1. Start dev: `./start.sh`
2. Add `.env` with Supabase credentials
3. Explore API at `/api/v1/...` endpoints
4. Review `CSS_DEVELOPMENT_GUIDE.md` for styling workflow

---

**Last Updated**: July 29, 2024  
**Status**: 🚧 Setup in progress 