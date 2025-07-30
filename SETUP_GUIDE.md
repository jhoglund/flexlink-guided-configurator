# FlexLink Guided Configuration Tool - Setup Guide

## 🏗️ Architecture Overview

This project uses a **dual-repository approach** with Docker containerization:

### Repository Structure
```
flexlink-pdf-extraction-tool/     # Python PDF extraction tools
├── extractors/                   # PDF processing scripts
├── data/                         # Extracted component data
└── database/                     # Supabase schemas

flexlink-guided-configuration-tool/  # Rails configuration app
├── app/                          # Rails application
├── docker/                       # Docker configuration
└── config/                       # Database configs
```

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

# Run background jobs
docker-compose exec sidekiq bundle exec sidekiq
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
- **Tables**: `conveyor_systems`, `component_specifications`
- **Access**: Read-only for Rails app
- **Sync**: Periodic data updates from PDF extraction

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

### PDF Extraction → Rails App
1. **Extract**: Python scripts process PDFs
2. **Upload**: Data pushed to Supabase
3. **Sync**: Rails app reads from Supabase API
4. **Cache**: Component data cached in Redis
5. **Serve**: Rails app serves configuration interface

### User Configuration Flow
1. **Start**: User begins guided configuration
2. **Progress**: Session stored in local PostgreSQL
3. **Selection**: Component choices saved locally
4. **Optimization**: Rails processes optimization logic
5. **Export**: Final configuration exported/emailed

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
- Never commit `.env` files
- Use different credentials for dev/staging/prod
- Rotate Supabase keys regularly

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

1. **Set up Rails application** with Docker
2. **Create database schemas** for local PostgreSQL
3. **Implement Supabase integration** for component data
4. **Build guided configuration wizard**
5. **Add team collaboration features**
6. **Deploy to free hosting platform**
7. **Set up monitoring and backups**

---

**Last Updated**: July 29, 2024  
**Status**: 🚧 Setup in progress 