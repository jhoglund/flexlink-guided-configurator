# CSS Development Guide

## Overview

This project uses **vanilla CSS** with the **Rails Asset Pipeline** for styling. All Tailwind CSS dependencies have been removed to ensure a clean, reliable development experience.

## ✅ **Current Setup**

### **Development Environment**
- **CSS Engine**: Vanilla CSS (no build tools required)
- **Asset Pipeline**: Rails Sprockets (automatic compilation)
- **Auto-reload**: Enabled in development
- **Cache Busting**: Automatic via Rails asset fingerprinting

### **Configuration**
```ruby
# config/environments/development.rb
config.assets.debug = true
config.assets.compile = true
config.assets.digest = false
config.assets.check_precompiled_asset = false
```

## 🚀 **CSS Development Workflow**

### **1. Make CSS Changes**
Edit `app/assets/stylesheets/application.css`:
```css
/* Your CSS changes here */
.my-new-class {
    color: red;
    background: blue;
}
```

### **2. Save the File**
CSS changes are automatically detected and compiled by Rails.

### **3. Refresh Browser**
- **Normal refresh**: `F5` or `Cmd+R`
- **Hard refresh**: `Ctrl+F5` or `Cmd+Shift+R` (clears cache)

### **4. Changes Should Be Visible**
CSS changes should appear immediately without any manual compilation steps.

## 🔧 **Troubleshooting**

### **If CSS Changes Don't Appear:**

#### **Option 1: Clear Rails Assets**
```bash
# Docker environment
docker-compose -f docker-compose.dev.yml exec web bin/rails assets:clobber

# Local environment
bin/rails assets:clobber
```

#### **Option 2: Use Development Helper**
```bash
./dev_css.sh
```

#### **Option 3: Force Browser Cache Clear**
- **Chrome/Edge**: `Ctrl+Shift+R` or `Cmd+Shift+R`
- **Firefox**: `Ctrl+F5` or `Cmd+Shift+R`
- **Safari**: `Cmd+Option+R`

### **If Still Not Working:**

1. **Check Rails logs**:
   ```bash
   docker-compose -f docker-compose.dev.yml logs web --tail=20
   ```

2. **Verify asset compilation**:
   ```bash
   docker-compose -f docker-compose.dev.yml exec web bin/rails assets:precompile
   ```

3. **Restart development server**:
   ```bash
   docker-compose -f docker-compose.dev.yml restart web
   ```

## 📁 **File Structure**

```
app/assets/stylesheets/
├── application.css          # Main stylesheet
├── fonts.css               # Font definitions
├── inter-direct.css        # Inter font styles
├── inter-test.css          # Font testing
└── rotis-fonts.css         # Rotis font styles
```

## 🎨 **CSS Organization**

### **Main Stylesheet**: `app/assets/stylesheets/application.css`
- **Base styles** and resets
- **FlexLink brand colors** (CSS variables)
- **Layout components** (header, nav, hero, buttons)
- **Responsive grid** system
- **Component styles** (cards, forms, etc.)

### **CSS Variables**
```css
:root {
    --flexlink-red: #d70a32;
    --flexlink-red-dark: #6b1e2a;
    --flexlink-medium-gray: #808080;
    --flexlink-dark-gray: #4a4a4a;
    /* ... more variables */
}
```

## 🔄 **Auto-Reload Features**

### **Development Mode**
- **CSS changes**: Auto-compiled and served
- **No build process**: Direct file editing
- **Live reload**: Guard watches for changes
- **Cache busting**: Automatic via Rails

### **Production Mode**
- **Precompiled assets**: Optimized and fingerprinted
- **CDN ready**: Proper asset URLs
- **Performance optimized**: Minified and compressed

## 🛠 **Development Commands**

### **Start Development Environment**
```bash
./start.sh                    # Docker-first with fallback
./start_dev.sh               # Docker only
./start_local.sh             # Local only
```

### **CSS Development Helper**
```bash
./dev_css.sh                 # Clear assets and restart
```

### **Asset Management**
```bash
# Clear compiled assets
bin/rails assets:clobber

# Precompile assets
bin/rails assets:precompile

# Check asset status
bin/rails assets:environment
```

## ✅ **Benefits of This Setup**

1. **No Build Tools**: Pure CSS, no compilation step
2. **Fast Development**: Changes appear immediately
3. **Rails Native**: Uses standard Rails asset pipeline
4. **Reliable**: No external dependencies or build processes
5. **Simple**: Just edit CSS and refresh browser
6. **Production Ready**: Proper asset fingerprinting and optimization

## 🚫 **What's Removed**

- ❌ **Tailwind CSS** - All dependencies removed
- ❌ **PostCSS** - No build tools needed
- ❌ **Node.js dependencies** - No package.json required
- ❌ **Build processes** - No compilation step
- ❌ **Watch modes** - Rails handles this automatically

## 🎯 **Best Practices**

1. **Use CSS Variables** for consistent theming
2. **Mobile-first** responsive design
3. **Semantic class names** for maintainability
4. **Modular CSS** organization
5. **Test in multiple browsers** regularly

## 📝 **Quick Reference**

| Action            | Command                                                |
| ----------------- | ------------------------------------------------------ |
| Start development | `./start.sh`                                           |
| Clear CSS cache   | `./dev_css.sh`                                         |
| View logs         | `docker-compose -f docker-compose.dev.yml logs web`    |
| Restart server    | `docker-compose -f docker-compose.dev.yml restart web` |

---

**✅ CSS development is now clean, fast, and reliable!** 