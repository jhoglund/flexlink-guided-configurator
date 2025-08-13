# FlexLink Guided Configurator

A Rails 8.0.2 web application for guided step-by-step configuration of FlexLink conveyor systems. This application integrates with Supabase for product data and provides a comprehensive interface for system configuration.

## 🚀 Quick Start

1. **Clone and setup**:
   ```bash
   git clone <repository-url>
   cd flexlink-guided-configurator
   cp env.example .env
   ```

2. **Start the application** (recommended):
   ```bash
   ./start.sh
   ```
   
   Or use specific environments:
   - `./start_dev.sh` - Docker development environment
   - `./start_local.sh` - Local development setup

3. **Open your browser**: http://localhost:3000

## 🏗️ Architecture

- **Backend**: Rails 8.0.2 with Ruby 3.3.1
- **Database**: PostgreSQL (local) + Supabase (remote product data)
- **Caching**: Redis for session storage and caching
- **Frontend**: Vanilla CSS with custom FlexLink branding
- **Containerization**: Docker with docker-compose.dev.yml
- **Development**: Guard for auto-reload functionality

## ✨ Key Features

1. **Guided Configuration Wizard**: 8-step process for system configuration
2. **System Management**: Complete FlexLink system catalog (17 systems)
3. **Component Integration**: Dynamic component selection based on system type
4. **Real-time Pricing**: Automatic pricing calculations
5. **Industry Categories**: 12 industry-specific categories with icons
6. **User Management**: Authentication and profile management
7. **Export Functionality**: JSON, PDF, CSV export capabilities

## 🗄️ Database Structure

- **Local PostgreSQL**: User data, configurations, wizard sessions, component selections
- **Supabase**: Product data (systems, components, images)
- **Redis**: Caching and background job processing

## 🛠️ Development

### CSS Styling
- **Vanilla CSS only**: Custom CSS with FlexLink brand colors and responsive design
- **CSS Variables**: Consistent color scheme and spacing
- **Responsive Grid**: Mobile-first approach with CSS Grid
- **No Build Process**: Direct CSS compilation by Rails asset pipeline

- `git-all "message"` - Quick git add/commit/push
- `cursor-new` - New Cursor chat with project context
- `cursor-help` - Show all available Cursor templates

## 🔧 Environment Setup

### Required Environment Variables
```bash
# Copy the example file
cp env.example .env

# Add your credentials (never commit .env)
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

## 🚀 Deployment

### Render Deployment
1. Connect your GitHub repository
2. Set environment variables in Render dashboard
3. Deploy automatically on push to main branch

### Environment Variables for Production
```bash
RAILS_MASTER_KEY=your_rails_master_key_here
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
DATABASE_URL=your_database_url
REDIS_URL=your_redis_url
```

## 🧪 Testing

Run the test suite:
```bash
# Docker environment
docker-compose -f docker-compose.dev.yml exec web bin/rails test

# Local environment
bin/rails test
```

## 🔐 Security

- **Master key protection** - `config/master.key` is in `.gitignore`
- **Credential management** - All sensitive data stored in environment variables
- **HTTPS enforcement** in production

📖 **See [SECURITY.md](SECURITY.md) for detailed security guidelines**

## 📚 Documentation

- [SETUP_GUIDE.md](SETUP_GUIDE.md) - Detailed setup instructions
- [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) - Deployment checklist
- [DOCKER_SETUP.md](DOCKER_SETUP.md) - Docker development guide
- [CURSOR_SETUP.md](CURSOR_SETUP.md) - Cursor AI integration guide
- [RENDER_DEPLOYMENT.md](RENDER_DEPLOYMENT.md) - Render deployment guide
- [TROUBLESHOOTING_DEPLOYMENT.md](TROUBLESHOOTING_DEPLOYMENT.md) - Deployment troubleshooting
- [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture and data flow
- [DATA_MODEL.md](DATA_MODEL.md) - Database entities and relationships
- [WIZARD_GUIDE.md](WIZARD_GUIDE.md) - 8-step wizard overview
- [API_GUIDE.md](API_GUIDE.md) - Public API endpoints
- [OPERATIONS.md](OPERATIONS.md) - Common ops and maintenance
- [STYLE_GUIDE.md](STYLE_GUIDE.md) - ERB/CSS conventions and branding

## 🎯 Status

- **Core Features**: ✅ Complete
- **Database**: ✅ PostgreSQL + Supabase integration
- **Styling**: ✅ Vanilla CSS with responsive design
- **Security**: ✅ All security measures implemented
- **Documentation**: ✅ Comprehensive guides
- **Deployment**: ✅ Production ready

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is proprietary to FlexLink and Coesia Group.

---

**Last Updated**: December 2024  
**Version**: 2.0.0 