# FlexLink Guided Configuration Tool

A Rails-based web application for guided step-by-step configuration of conveyor belt systems. This tool integrates with Supabase for product data and provides a modern, user-friendly interface for system configuration.

## 🏗️ Architecture

- **Rails 7.0**: Modern web framework with Turbo and Stimulus
- **PostgreSQL**: Local database for application data
- **Redis**: Caching and session storage
- **Supabase**: Remote product database (read-only)
- **Docker**: Containerized development environment
- **Bootstrap 5**: Modern UI framework

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose
- Git

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flexlink-guided-configurator
   ```

2. **Set up environment variables**
   ```bash
   cp env.example .env
   # Edit .env with your Supabase credentials
   ```

3. **Start the application**
   ```bash
   docker-compose up --build
   ```

4. **Access the application**
   - Web interface: http://localhost:3000
   - PostgreSQL: localhost:5432
   - Redis: localhost:6379

## 📋 Features

### Guided Configuration Wizard
- **8-step process** for system configuration
- **Progress tracking** with visual indicators
- **Validation** at each step
- **Session management** for incomplete configurations

### Component Management
- **Dynamic component selection** based on system type
- **Real-time pricing** and specifications
- **Component filtering** and search
- **Quantity management** and notes

### User Management
- **User registration** and authentication
- **Profile management** with company information
- **Configuration history** and tracking
- **Export functionality** (JSON, PDF, CSV)

### Integration
- **Supabase integration** for product data
- **Redis caching** for performance
- **Background job processing** with Sidekiq
- **API endpoints** for external access

## 🗄️ Database Structure

### Local PostgreSQL (Application Data)
- `users` - User accounts and profiles
- `configurations` - System configurations
- `wizard_sessions` - Wizard progress tracking
- `component_selections` - User component choices

### Supabase (Product Data)
- `conveyor_systems` - System specifications
- `component_specifications` - Component catalog

## 🔧 Development

### Running Locally

```bash
# Start all services
docker-compose up

# Run migrations
docker-compose exec web rails db:migrate

# Access Rails console
docker-compose exec web rails console

# View logs
docker-compose logs -f web
```

### Database Operations

```bash
# Reset database
docker-compose exec web rails db:reset

# Run seeds
docker-compose exec web rails db:seed

# Backup database
docker-compose exec postgres pg_dump -U flexlink_user flexlink_config > backup.sql
```

### Testing

```bash
# Run tests
docker-compose exec web rails test

# Run specific tests
docker-compose exec web rails test test/controllers/configurations_controller_test.rb
```

## 🎯 Wizard Steps

1. **System Type Selection** - Choose conveyor system type
2. **System Specifications** - Configure system parameters
3. **Component Type Selection** - Select component categories
4. **Component Selection 1** - Choose first component type
5. **Component Selection 2** - Choose second component type
6. **Component Selection 3** - Choose third component type
7. **Component Selection 4** - Choose fourth component type
8. **Review and Complete** - Review configuration and export

## 🔌 API Endpoints

### Configurations
- `GET /configurations` - List user configurations
- `POST /configurations` - Create new configuration
- `GET /configurations/:id` - View configuration
- `PATCH /configurations/:id` - Update configuration
- `DELETE /configurations/:id` - Delete configuration

### Wizard
- `GET /wizard/step/:step` - Access wizard step
- `PATCH /wizard/step/:step` - Update step data
- `GET /wizard/summary` - View configuration summary
- `POST /wizard/complete` - Complete configuration

### API (Supabase Integration)
- `GET /api/v1/conveyor_systems` - List conveyor systems
- `GET /api/v1/component_specifications` - List components
- `GET /api/v1/component_specifications/search` - Search components

## 🚀 Deployment

### Free Hosting Options

#### Railway (Recommended)
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login and deploy
railway login
railway init
railway up
```

#### Render
- Connect GitHub repository
- Set environment variables
- Deploy automatically

### Environment Variables

```bash
# Supabase Configuration
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key

# Rails Configuration
RAILS_ENV=production
RAILS_MASTER_KEY=your_master_key

# Database Configuration
DATABASE_URL=your_database_url

# Redis Configuration
REDIS_URL=your_redis_url
```

## 🔒 Security

- **Authentication** with Devise
- **Authorization** with Pundit
- **CSRF protection** enabled
- **Secure headers** configured
- **Environment variable** management

## 📊 Monitoring

- **Health checks** for all services
- **Log aggregation** with structured logging
- **Performance monitoring** with Redis caching
- **Error tracking** and reporting

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

---

**Last Updated**: <%= Date.current.strftime("%B %d, %Y") %>  
**Version**: 1.0.0  
**Status**: 🚧 Development 