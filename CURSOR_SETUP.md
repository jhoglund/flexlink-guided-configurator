# Cursor AI Setup Guide

## Overview
This document explains how to ensure Cursor AI understands the full context and intention of the FlexLink Guided Configurator project in new chats.

## 🎯 **Best Approach: Project Context File**

### `.cursorrules` File
The most effective approach is the `.cursorrules` file in your project root. Cursor automatically reads this file in new chats, providing instant project context.

**Location**: `/.cursorrules`

**Benefits**:
- ✅ **Automatic Context**: Read automatically in new chats
- ✅ **No Manual Typing**: No need to explain project every time
- ✅ **Consistent Understanding**: Same context across all chats
- ✅ **Project-Specific**: Tailored to your FlexLink project

## 🚀 **Additional Strategies**

### **1. Quick Prompt Template**
When starting a new chat, you can use this template:

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

### **2. Cursor Settings Configuration**
Configure workspace-specific settings in `.vscode/settings.json`:

```json
{
  "cursor.projectContext": {
    "description": "FlexLink Guided Configurator - Rails 8.0.2 app for guided step-by-step configuration of FlexLink conveyor systems",
    "keyFiles": [
      "README.md",
      "SECURITY.md",
      "SETUP_GUIDE.md",
      "docker-compose.dev.yml",
      "app/models/system.rb",
      "app/models/component.rb",
      "app/controllers/home_controller.rb",
      "config/routes.rb",
      "app/assets/stylesheets/application.css",
      "CSS_DEVELOPMENT_GUIDE.md",
      "app/views/home/index.html.erb"
    ],
    "importantNotes": [
      "Keep all debug elements as requested",
      "Security-first: all credentials in environment variables",
      "Uses Supabase for product data, PostgreSQL for app data",
      "Vanilla CSS with custom FlexLink branding (no Tailwind CSS)",
      "Docker development environment with auto-reload",
      "Rails Asset Pipeline for CSS compilation",
      "No build tools required for CSS development"
    ]
  }
}
```

### **3. Workspace Configuration**
The `.vscode/settings.json` file provides:
- **Project Description**: Clear overview for Cursor
- **Key Files**: Important files for context
- **Important Notes**: Critical reminders and constraints
- **File Associations**: Proper language support
- **CSS Validation**: Proper CSS linting and validation

## 📋 **Recommended Usage Patterns**

### **For New Chats:**
1. **Start with the `.cursorrules` file** - Cursor will automatically read this
2. **Use the quick prompt template** if needed
3. **Reference key files** when asking specific questions

### **For Complex Tasks:**
```
Please read the .cursorrules file and then help me with [specific task]. 
Key considerations: [list specific requirements]
```

### **For Debugging:**
```
I'm debugging [specific issue]. Please consider:
- The project uses Rails 8.0.2 with Docker
- Keep all debug elements as requested
- Security-first approach with environment variables
- Vanilla CSS with Rails Asset Pipeline
- Read .cursorrules for full context
```

### **For Feature Development:**
```
I'm adding a new feature to the FlexLink configurator. Please consider:
- Follow existing patterns in the codebase
- Maintain security practices (no hardcoded credentials)
- Use vanilla CSS with FlexLink branding (no Tailwind)
- Keep debug elements as requested
- Use Rails Asset Pipeline for CSS compilation
```

### **For CSS Development:**
```
I'm working on CSS styling. Please consider:
- Use vanilla CSS only (no Tailwind CSS)
- Follow existing CSS patterns in application.css
- Use CSS variables for FlexLink brand colors
- Mobile-first responsive design
- Rails Asset Pipeline handles compilation
```

## 🔧 **Setup Instructions**

### **1. Verify `.cursorrules` File**
Ensure the `.cursorrules` file exists in your project root and contains:
- Project overview and architecture
- Key features and database structure
- Development setup instructions
- Security considerations
- Debug element requirements
- File structure and key models
- CSS development workflow
- Common tasks and important notes

### **2. Check Workspace Settings**
Verify `.vscode/settings.json` contains:
- `cursor.projectContext` configuration
- Proper file associations for ERB files
- Emmet support for HTML in ERB files
- CSS validation settings
- File exclusion patterns

### **3. Test in New Chat**
Start a new Cursor chat and verify:
- Cursor understands the project context
- No need to explain basic project details
- Security considerations are understood
- Debug elements are preserved
- CSS development workflow is clear

## 🎯 **Key Benefits**

### **Automatic Context**
- No need to explain project basics in every chat
- Consistent understanding across sessions
- Reduced typing and setup time

### **Project-Specific Understanding**
- Tailored to FlexLink project requirements
- Aware of security constraints
- Understands debug element requirements
- Knows CSS development workflow

### **Efficient Development**
- Faster responses with proper context
- Better code suggestions
- Reduced back-and-forth clarification
- Proper CSS development guidance

## 📚 **File Structure**

```
flexlink-guided-configurator/
├── .cursorrules                    # Main context file (auto-read)
├── .vscode/
│   └── settings.json              # Workspace configuration
├── README.md                      # Project documentation
├── SECURITY.md                    # Security guidelines
├── SETUP_GUIDE.md                # Development setup
├── CSS_DEVELOPMENT_GUIDE.md      # CSS development guide
└── app/assets/stylesheets/
    └── application.css            # Main CSS file
```

## 🚨 **Important Reminders**

### **Always Mention:**
- Keep all debug elements as requested
- Security-first approach with environment variables
- Docker development environment
- Vanilla CSS with FlexLink branding (no Tailwind)
- Rails Asset Pipeline for CSS compilation

### **Key Constraints:**
- Never commit credentials to version control
- All sensitive data in environment variables
- Maintain debug elements for development
- Follow existing code patterns
- Use vanilla CSS only (no Tailwind CSS)
- No build tools required for CSS development

## 🔄 **Updating Context**

When the project evolves:
1. **Update `.cursorrules`** with new features or changes
2. **Modify `.vscode/settings.json`** if needed
3. **Test in new chat** to verify context is current

## 🎨 **CSS Development Context**

### **Key Points for CSS Work:**
- **Vanilla CSS only** - no Tailwind CSS
- **Rails Asset Pipeline** handles compilation
- **CSS Variables** for FlexLink brand colors
- **Mobile-first responsive design**
- **Immediate changes** - edit CSS and refresh browser
- **No build tools required**

### **CSS File Structure:**
```
app/assets/stylesheets/
├── application.css          # Main stylesheet
├── fonts.css               # Font definitions
├── inter-direct.css        # Inter font styles
├── inter-test.css          # Font testing
└── rotis-fonts.css         # Rotis font styles
```

---

**Last Updated**: December 2024  
**Status**: ✅ Configured and tested with vanilla CSS workflow 