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
- Tailwind CSS with custom FlexLink branding
- Docker development environment with auto-reload
- 8-step guided configuration wizard
- Keep all debug elements as requested
- Security-first: all credentials in environment variables

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
      "tailwind.config.js"
    ],
    "importantNotes": [
      "Keep all debug elements as requested",
      "Security-first: all credentials in environment variables",
      "Uses Supabase for product data, PostgreSQL for app data",
      "Tailwind CSS with custom FlexLink branding",
      "Docker development environment with auto-reload"
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
- Read .cursorrules for full context
```

### **For Feature Development:**
```
I'm adding a new feature to the FlexLink configurator. Please consider:
- Follow existing patterns in the codebase
- Maintain security practices (no hardcoded credentials)
- Use Tailwind CSS with FlexLink branding
- Keep debug elements as requested
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
- Common tasks and important notes

### **2. Check Workspace Settings**
Verify `.vscode/settings.json` contains:
- `cursor.projectContext` configuration
- Proper file associations for ERB files
- Emmet support for HTML in ERB files

### **3. Test in New Chat**
Start a new Cursor chat and verify:
- Cursor understands the project context
- No need to explain basic project details
- Security considerations are understood
- Debug elements are preserved

## 🎯 **Key Benefits**

### **Automatic Context**
- No need to explain project basics in every chat
- Consistent understanding across sessions
- Reduced typing and setup time

### **Project-Specific Understanding**
- Tailored to FlexLink project requirements
- Aware of security constraints
- Understands debug element requirements

### **Efficient Development**
- Faster responses with proper context
- Better code suggestions
- Reduced back-and-forth clarification

## 📚 **File Structure**

```
flexlink-guided-configurator/
├── .cursorrules                    # Main context file (auto-read)
├── .vscode/
│   └── settings.json              # Workspace configuration
├── README.md                      # Project documentation
├── SECURITY.md                    # Security guidelines
└── SETUP_GUIDE.md                # Development setup
```

## 🚨 **Important Reminders**

### **Always Mention:**
- Keep all debug elements as requested
- Security-first approach with environment variables
- Docker development environment
- Tailwind CSS with FlexLink branding

### **Key Constraints:**
- Never commit credentials to version control
- All sensitive data in environment variables
- Maintain debug elements for development
- Follow existing code patterns

## 🔄 **Updating Context**

When the project evolves:
1. **Update `.cursorrules`** with new features or changes
2. **Modify `.vscode/settings.json`** if needed
3. **Test in new chat** to verify context is current

---

**Last Updated**: December 2024  
**Status**: ✅ Configured and tested 