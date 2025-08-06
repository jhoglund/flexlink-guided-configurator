# Cursor AI Prompt Templates Guide

## 🚀 **Quick Commands (Shell Functions)**

I've created shell functions that copy templates to your clipboard. Just run the command, then paste in Cursor!

### **Available Commands:**
```bash
cursor-new      # New chat template
cursor-debug    # Debugging template  
cursor-feature  # Feature development template
cursor-security # Security-focused template
cursor-help     # Show all available templates
```

### **Usage:**
1. **Run the command** in terminal
2. **Open Cursor** and start new chat
3. **Paste** (Cmd+V) the template
4. **Customize** the message as needed

---

## 📋 **Template Details**

### **1. New Chat Template** (`cursor-new`)
```bash
cursor-new
```
**Copies to clipboard:**
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

### **2. Debugging Template** (`cursor-debug`)
```bash
cursor-debug
```
**Copies to clipboard:**
```
I'm debugging [specific issue]. Please consider:
- The project uses Rails 8.0.2 with Docker
- Keep all debug elements as requested
- Security-first approach with environment variables
- Read .cursorrules for full context
```

### **3. Feature Development Template** (`cursor-feature`)
```bash
cursor-feature
```
**Copies to clipboard:**
```
I'm adding a new feature to the FlexLink configurator. Please consider:
- Follow existing patterns in the codebase
- Maintain security practices (no hardcoded credentials)
- Use Tailwind CSS with FlexLink branding
- Keep debug elements as requested
```

### **4. Security Template** (`cursor-security`)
```bash
cursor-security
```
**Copies to clipboard:**
```
I'm working on security aspects of the FlexLink configurator. Please consider:
- All credentials in environment variables
- Never commit secrets to version control
- Use Rails master key protection
- Follow security-first approach
- Read SECURITY.md for guidelines
```

---

## 🎯 **Advanced Usage Patterns**

### **Custom Templates**
You can create your own templates by adding functions to `/Users/jonashoglund/dotfiles/aliases`:

```bash
# Example: Add a new template
echo 'cursor-test() { echo "I'\''m writing tests for the FlexLink configurator. Please consider: Use RSpec patterns, Test both happy and edge cases, Mock external services, Follow existing test structure" | pbcopy && echo "✅ Cursor test template copied!"; }' >> /Users/jonashoglund/dotfiles/aliases
```

### **Combined Templates**
You can combine templates for specific scenarios:

```bash
# For a complex feature with security considerations
cursor-feature
# Then add: "Also consider security aspects: [paste cursor-security content]"
```

### **Quick Customization**
After pasting a template, quickly customize it:

```bash
# Replace placeholders
[specific issue] → "user authentication failing"
[new feature] → "export to PDF functionality"
```

---

## 🔧 **Alternative Approaches**

### **1. TextExpander/Snippets**
If you use TextExpander or similar tools:
- Create snippets for each template
- Use keyboard shortcuts (e.g., `;cursor` → new chat template)
- Sync across all applications

### **2. VS Code Snippets**
Create snippets in VS Code:
1. **Open Command Palette** (`Cmd+Shift+P`)
2. **"Preferences: Configure User Snippets"**
3. **Select "markdown"** (for Cursor chats)
4. **Add snippets:**

```json
{
  "Cursor New Chat": {
    "prefix": "cursor-new",
    "body": [
      "I'm working on the FlexLink Guided Configurator - a Rails 8.0.2 app for configuring FlexLink conveyor systems.",
      "",
      "Key context:",
      "- Uses Supabase for product data, PostgreSQL for app data, Redis for caching",
      "- Tailwind CSS with custom FlexLink branding", 
      "- Docker development environment with auto-reload",
      "- 8-step guided configuration wizard",
      "- Keep all debug elements as requested",
      "- Security-first: all credentials in environment variables",
      "",
      "Please read the .cursorrules file for full project context."
    ]
  }
}
```

### **3. Alfred/Raycast Workflows**
Create workflows that:
- Copy templates to clipboard
- Open Cursor automatically
- Insert templates with hotkeys

---

## 📱 **Mobile/Quick Access**

### **Notes App Template**
Create a note with all templates for quick copy-paste:

```
📋 Cursor Templates

NEW CHAT:
I'm working on the FlexLink Guided Configurator...

DEBUG:
I'm debugging [specific issue]...

FEATURE:
I'm adding a new feature...

SECURITY:
I'm working on security aspects...
```

### **Bookmark Templates**
Create browser bookmarks with templates in the URL (encoded):
- Quick access from any device
- No terminal needed

---

## 🎯 **Best Practices**

### **1. Template Customization**
- **Always customize** the template for your specific task
- **Add context** about what you're working on
- **Mention specific files** if relevant

### **2. Progressive Disclosure**
- **Start with basic template** for simple questions
- **Add more context** for complex tasks
- **Reference specific files** when needed

### **3. Template Evolution**
- **Update templates** as project evolves
- **Add new templates** for common scenarios
- **Remove unused templates** to keep things clean

### **4. Team Sharing**
- **Share templates** with team members
- **Document template usage** in project docs
- **Standardize templates** across team

---

## 🚀 **Quick Reference**

### **Most Common Usage:**
```bash
# Start new chat
cursor-new

# Debug an issue
cursor-debug

# Add new feature
cursor-feature

# Security work
cursor-security
```

### **Workflow:**
1. **Run command** → Template copied to clipboard
2. **Open Cursor** → Start new chat
3. **Paste template** → Customize as needed
4. **Ask your question** → Get contextual help

### **Benefits:**
- ✅ **No typing** - Templates ready to use
- ✅ **Consistent** - Same context every time
- ✅ **Fast** - One command to get started
- ✅ **Customizable** - Easy to modify for specific needs

---

**Last Updated**: December 2024  
**Status**: ✅ Templates configured and tested 