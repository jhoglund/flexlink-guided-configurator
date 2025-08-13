# Cursor Quick Reference Guide

## 🚀 **Quick Start**

### **New Chat Template**
```
I'm working on the FlexLink Guided Configurator - a Rails 8.0.2 app for configuring FlexLink conveyor systems. 

Key context:
- Uses Supabase for product data, PostgreSQL for app data, Redis for caching
- Vanilla CSS with custom FlexLink branding (no Tailwind CSS)
- Docker development environment with auto-reload
- 8-step guided configuration wizard
- Keep all debug elements as requested
- Security-first: all credentials in environment variables
- Rails Asset Pipeline for CSS compilation

Please read the .cursorrules file for full project context.
```

## 📁 **Key Files**

### **Core Configuration**
- `.cursorrules` - Main project context (auto-read by Cursor)
- `.vscode/settings.json` - Workspace configuration
- `docker-compose.dev.yml` - Development environment

### **Application Files**
- `app/models/system.rb` - System model
- `app/models/component.rb` - Component model
- `app/controllers/home_controller.rb` - Main controller
- `app/views/home/index.html.erb` - Home page
- `app/assets/stylesheets/application.css` - Main CSS file

### **Documentation**
- `README.md` - Project overview
- `SECURITY.md` - Security guidelines
- `SETUP_GUIDE.md` - Development setup
- `CSS_DEVELOPMENT_GUIDE.md` - CSS workflow

## 🎯 **Common Tasks**

### **Development Commands**
```bash
./start.sh                    # Docker-first with fallback
./start_dev.sh               # Docker only
./start_local.sh             # Local only
./dev_css.sh                 # Clear assets and restart
./reset_db.sh                # Reset database
```

### **CSS Development**
- Edit `app/assets/stylesheets/application.css`
- Save file
- Refresh browser
- Changes appear immediately

### **Git Commands**
```bash
git-all "message"            # Quick git add/commit/push
```

## 🔧 **Key Constraints**

### **Security**
- ✅ All credentials in environment variables
- ✅ Never commit credentials to version control
- ✅ Rails master key in `.gitignore`

### **Development**
- ✅ Keep all debug elements as requested
- ✅ Use vanilla CSS only (no Tailwind)
- ✅ Follow existing code patterns
- ✅ Docker development environment

### **CSS Workflow**
- ✅ Rails Asset Pipeline for compilation
- ✅ CSS Variables for FlexLink branding
- ✅ Mobile-first responsive design
- ✅ No build tools required

## 🎨 **CSS Variables**

```css
:root {
    --flexlink-red: #d70a32;
    --flexlink-red-dark: #6b1e2a;
    --flexlink-medium-gray: #808080;
    --flexlink-dark-gray: #4a4a4a;
    --gray-50: #f9fafb;
    --gray-100: #f3f4f6;
    --gray-200: #e5e7eb;
    --gray-300: #d1d5db;
    --gray-400: #9ca3af;
    --gray-500: #6b7280;
    --gray-600: #4b5563;
    --gray-700: #374151;
    --gray-800: #1f2937;
    --gray-900: #111827;
}
```

## 📋 **Project Architecture**

### **Backend**
- Rails 8.0.2 with Ruby 3.3.1
- PostgreSQL (local) + Supabase (remote)
- Redis for caching
- Docker development environment

### **Frontend**
- Vanilla CSS (no Tailwind)
- Rails Asset Pipeline
- Responsive design
- FlexLink branding

### **Key Features**
- 8-step guided configuration wizard
- 17 FlexLink system catalog
- 12 industry categories
- Real-time pricing
- Export functionality (JSON, PDF, CSV)

## 🔍 **Troubleshooting**

### **CSS Changes Not Appearing**
1. Clear assets: `./dev_css.sh`
2. Hard refresh browser: `Cmd+Shift+R`
3. Check Rails logs: `docker-compose -f docker-compose.dev.yml logs web`

### **Development Environment Issues**
1. Restart Docker: `docker-compose -f docker-compose.dev.yml restart`
2. Rebuild containers: `docker-compose -f docker-compose.dev.yml up --build`
3. Check environment variables in `.env` file

### **Database Issues**
1. Reset database: `./reset_db.sh`
2. Check migrations: `bin/rails db:migrate:status`
3. Seed data: `bin/rails db:seed`

## 📝 **Quick Prompts**

### **For Feature Development**
```
I'm adding [feature] to the FlexLink configurator. Please consider:
- Follow existing patterns in the codebase
- Maintain security practices (no hardcoded credentials)
- Use vanilla CSS with FlexLink branding (no Tailwind)
- Keep debug elements as requested
- Use Rails Asset Pipeline for CSS compilation
```

### **For CSS Development**
```
I'm working on CSS styling. Please consider:
- Use vanilla CSS only (no Tailwind CSS)
- Follow existing CSS patterns in application.css
- Use CSS variables for FlexLink brand colors
- Mobile-first responsive design
- Rails Asset Pipeline handles compilation
```

### **For Debugging**
```
I'm debugging [issue]. Please consider:
- The project uses Rails 8.0.2 with Docker
- Keep all debug elements as requested
- Security-first approach with environment variables
- Vanilla CSS with Rails Asset Pipeline
- Read .cursorrules for full context
```

## 🎯 **Best Practices**

1. **Always read `.cursorrules`** in new chats
2. **Keep debug elements** as requested
3. **Use environment variables** for all credentials
4. **Follow existing code patterns**
5. **Test in multiple browsers** for CSS changes
6. **Use CSS variables** for consistent theming
7. **Mobile-first responsive design**

---

**Last Updated**: December 2024  
**Status**: ✅ Ready for development 