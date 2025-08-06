# FlexLink Guided Configuration Tool

A modern Rails 8.0.2 web application for guided step-by-step configuration of FlexLink conveyor systems. This tool integrates with Supabase for product data and provides a comprehensive interface for system configuration with automatic testing and development tools.

## 🏗️ Architecture

- **Rails 8.0.2**: Modern web framework with Turbo and Stimulus
- **PostgreSQL**: Local database for application data
- **Redis**: Caching and session storage
- **Supabase**: Remote product database (read-only)
- **Docker**: Containerized development environment
- **Tailwind CSS**: Modern utility-first CSS framework
- **Guard**: Automatic testing with real-time feedback

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose
- Git
- Ruby 3.3.1 (for local development)

### Environment Setup

1. **Copy environment template**:
   ```bash
   cp env.example .env
   ```

2. **Configure Supabase credentials** in `.env`:
   ```bash
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

**⚠️ Security Note**: Never commit your `.env` file to version control. It's already in `.gitignore`.

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
   # Option 1: Use the default start script (recommended)
   ./start.sh
   
   # Option 2: Use Docker development environment
   ./start_dev.sh
   
   # Option 3: Use local development (no Docker)
   ./start_local.sh
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

### System Management
- **FlexLink Systems** - Complete system catalog with specifications
- **Component Integration** - Dynamic component selection based on system type
- **Real-time pricing** and specifications
- **System compatibility** checking
- **Image management** for systems and components

### Component Management
- **Dynamic component selection** based on system type
- **Real-time pricing** and specifications
- **Component filtering** and search
- **Quantity management** and notes
- **Compatibility matrix** for components

### User Management
- **User registration** and authentication
- **Profile management** with company information
- **Configuration history** and tracking
- **Export functionality** (JSON, PDF, CSV)

### Integration
- **Supabase integration** for product data
- **Redis caching** for performance
- **Background job processing** with Sidekiq
- **RESTful API endpoints** for external access

## 🗄️ Database Structure

### Local PostgreSQL (Application Data)
- `users` - User accounts and profiles
- `configurations` - System configurations with total pricing
- `wizard_sessions` - Wizard progress tracking
- `component_selections` - User component choices with system codes

### Supabase (Product Data)
- `systems` - FlexLink system specifications and features
- `components` - Component catalog with specifications
- `product_images` - System and component images
- **Views**: `system_overview`, `component_compatibility`, `system_stats`
- **Functions**: `search_systems`, `get_system_stats`

## 🔧 Development

### Running Locally

```bash

### CSS Troubleshooting

If you encounter styling issues (missing colors, fonts, or layout), follow these steps:

1. **Recompile CSS manually**:
   ```bash
   npx tailwindcss -c tailwind.config.js -i ./app/assets/stylesheets/application.css -o ./app/assets/builds/application.css --minify
   ```

2. **Copy CSS to public assets**:
   ```bash
   cp ./app/assets/builds/application.css ./public/assets/application.css
   ```

3. **Restart the web service**:
   ```bash
   docker-compose -f docker-compose.dev.yml restart web
   ```

4. **Clear browser cache** and refresh the page

### CSS Development

For active CSS development, run the watch script in a separate terminal:
```bash
./bin/watch-css
```

This will automatically recompile CSS when you make changes to `app/assets/stylesheets/application.css`.
# Start all services
docker-compose up

# Run migrations
docker-compose exec web rails db:migrate

# Access Rails console
docker-compose exec web rails console

# View logs
docker-compose logs -f web
```

### Testing with Guard

```bash
# Start automatic testing
bundle exec guard

# Guard commands:
# Enter - Run all tests
# a - Run all tests
# p - Run failed tests only
# w - Run tests for changed files
# q - Quit Guard
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
# Run all tests
bin/rails test

# Run specific test files
bin/rails test test/models/
bin/rails test test/controllers/
bin/rails test test/services/

# Run with clean output (no deprecation warnings)
bin/rails test test/models/basic_test.rb
```

## 🎯 Wizard Steps

1. **System Type Selection** - Choose FlexLink system type
2. **System Specifications** - Configure system parameters
3. **Component Type Selection** - Select component categories
4. **Component Selection 1** - Choose first component type
5. **Component Selection 2** - Choose second component type
6. **Component Selection 3** - Choose third component type
7. **Component Selection 4** - Choose fourth component type
8. **Review and Complete** - Review configuration and export

## 🔌 API Endpoints

### Systems
- `GET /systems` - List all FlexLink systems
- `GET /systems/:id` - View system details
- `GET /systems/:id/components` - Get system components
- `GET /systems/:id/images` - Get system images
- `GET /systems/search` - Search systems
- `GET /systems/stats` - Get system statistics

### Components
- `GET /components` - List all components
- `GET /components/:id` - View component details
- `GET /components/by_system/:system_code` - Get components by system
- `GET /components/search` - Search components

### API (Supabase Integration)
- `GET /api/v1/systems` - List systems from Supabase
- `GET /api/v1/systems/:id` - Get system details
- `GET /api/v1/systems/search` - Search systems
- `GET /api/v1/systems/stats` - Get system statistics
- `GET /api/v1/components` - List components from Supabase
- `GET /api/v1/components/:id` - Get component details
- `GET /api/v1/components/by_system/:system_code` - Get components by system
- `GET /api/v1/product_images` - Get product images
- `GET /api/v1/product_images/by_system/:system_code` - Get images by system

### Legacy Endpoints (Deprecated)
- `GET /api/v1/conveyor_systems` - Legacy endpoint (redirects to systems)
- `GET /api/v1/component_specifications` - Legacy endpoint (redirects to components)

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
- **Master key protection** - `config/master.key` is in `.gitignore`
- **Credential management** - All sensitive data stored in environment variables
- **HTTPS enforcement** in production

📖 **See [SECURITY.md](SECURITY.md) for detailed security guidelines**

## 📊 Monitoring

- **Health checks** for all services
- **Log aggregation** with structured logging
- **Performance monitoring** with Redis caching
- **Error tracking** and reporting

## 🧪 Testing

### Test Coverage
- **43 model tests** covering System and Component models
- **Clean test output** with no deprecation warnings
- **Automatic testing** with Guard
- **Fast execution** (0.65 seconds for all model tests)

### Test Structure
- `test/models/system_test.rb` - System model tests
- `test/models/component_test.rb` - Component model tests
- `test/models/basic_test.rb` - Basic functionality tests
- `test/test_helper.rb` - Test configuration

### Guard Configuration
- **Watches** `app/`, `config/`, `test/` directories
- **Automatic test execution** on file changes
- **Clean output** with no configuration warnings
- **Fast feedback** during development

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests (ensure all tests pass)
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

---

**Last Updated**: December 2024  
**Version**: 2.0.0  
**Status**: 🚀 Production Ready  
**Rails Version**: 8.0.2  
**Ruby Version**: 3.3.1  
**Security**: ✅ All security measures implemented 