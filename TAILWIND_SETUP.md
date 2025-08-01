# Tailwind CSS Setup for FlexLink Configurator

## Overview
This document describes the Tailwind CSS configuration for the FlexLink Configurator application, including the custom color palette and component classes.

## Configuration Files

### 1. `tailwind.config.js`
The main Tailwind configuration file that defines:
- Custom FlexLink color palette
- Custom gradients and backgrounds
- Custom animations and keyframes
- Custom shadows and spacing
- Font family configuration

### 2. `package.json`
Node.js dependencies and build scripts for Tailwind CSS.

### 3. `postcss.config.js`
PostCSS configuration for processing Tailwind CSS.

### 4. `app/assets/stylesheets/application.css`
Main stylesheet with Tailwind directives and custom component classes.

## FlexLink Color Palette

### Primary Colors
```css
/* FlexLink Brand Colors */
--flexlink-red: #8B2635;        /* Primary red */
--flexlink-red-dark: #6B1E2A;   /* Darker red for hover */
--flexlink-red-light: #D70A32;  /* Bright red from gradient */
--flexlink-red-deep: #A10221;   /* Deep red from gradient */
--flexlink-black: #000000;      /* Pure black */
--flexlink-white: #FFFFFF;      /* Pure white */
--flexlink-dark-gray: #4A4A4A;  /* Dark gray */
--flexlink-light-gray: #F5F5F5; /* Light gray */
--flexlink-medium-gray: #808080; /* Medium gray */
```

### Tailwind Class Mapping
```html
<!-- Background Colors -->
bg-flexlink-red          /* #8B2635 */
bg-flexlink-red-dark     /* #6B1E2A */
bg-flexlink-red-light    /* #D70A32 */
bg-flexlink-red-deep     /* #A10221 */
bg-flexlink-black        /* #000000 */
bg-flexlink-white        /* #FFFFFF */
bg-flexlink-dark-gray    /* #4A4A4A */
bg-flexlink-light-gray   /* #F5F5F5 */
bg-flexlink-medium-gray  /* #808080 */

<!-- Text Colors -->
text-flexlink-red
text-flexlink-red-dark
text-flexlink-red-light
text-flexlink-red-deep
text-flexlink-black
text-flexlink-white
text-flexlink-dark-gray
text-flexlink-light-gray
text-flexlink-medium-gray
```

## Custom Gradients

### Radial Gradients
```html
<!-- From Figma Design -->
bg-radial-gradient        /* #D70A32 to #A10221 */
bg-radial-gradient-reverse /* #A10221 to #D70A32 */
bg-radial-gradient-soft   /* Soft version with transparency */
```

### Linear Gradients
```html
bg-gradient-primary       /* FlexLink red gradient */
bg-gradient-secondary     /* Purple gradient for headers */
```

## Custom Component Classes

### Buttons
```html
<!-- Primary Button -->
<button class="btn-flexlink-primary">
  Primary Action
</button>

<!-- Secondary Button -->
<button class="btn-flexlink-secondary">
  Secondary Action
</button>
```

### Cards
```html
<!-- Standard Card -->
<div class="card-flexlink">
  Card content
</div>

<!-- Panel with Gradient -->
<div class="panel-flexlink">
  Panel content
</div>

<!-- Banner with Radial Gradient -->
<div class="banner-flexlink">
  Banner content
</div>
```

### Forms
```html
<!-- Form Input -->
<input class="form-input-flexlink" type="text" placeholder="Enter text">
```

### Alerts
```html
<!-- Success Alert -->
<div class="alert-flexlink-success">
  Success message
</div>

<!-- Error Alert -->
<div class="alert-flexlink-error">
  Error message
</div>

<!-- Warning Alert -->
<div class="alert-flexlink-warning">
  Warning message
</div>
```

## Custom Shadows

### FlexLink Shadows
```html
shadow-flexlink      /* Light red shadow */
shadow-flexlink-lg   /* Medium red shadow */
shadow-flexlink-xl   /* Heavy red shadow */
```

## Custom Animations

### Fade In
```html
<div class="animate-fade-in">
  Content that fades in
</div>
```

### Slide Up
```html
<div class="animate-slide-up">
  Content that slides up
</div>
```

### Slow Pulse
```html
<div class="animate-pulse-slow">
  Slowly pulsing content
</div>
```

## Development Setup

### 1. Install Dependencies
```bash
npm install
```

### 2. Build CSS for Development
```bash
npm run build:css
```

### 3. Build CSS for Production
```bash
npm run build:css:prod
```

### 4. Watch for Changes
```bash
npm run dev
```

## Usage Examples

### Dashboard Cards
```html
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
  <div class="card-flexlink">
    <div class="flex items-center space-x-4">
      <div class="text-3xl">📊</div>
      <div>
        <h3 class="text-2xl font-bold text-gray-900">42</h3>
        <p class="text-gray-600">Total Configurations</p>
      </div>
    </div>
  </div>
</div>
```

### Action Buttons
```html
<div class="flex space-x-4">
  <button class="btn-flexlink-primary">
    <i class="fas fa-plus mr-2"></i>
    New Configuration
  </button>
  <button class="btn-flexlink-secondary">
    <i class="fas fa-cog mr-2"></i>
    Settings
  </button>
</div>
```

### Gradient Panels
```html
<div class="panel-flexlink">
  <h2 class="text-xl font-bold mb-4">Welcome to FlexLink</h2>
  <p class="text-white opacity-90">
    Configure your conveyor system with our guided wizard.
  </p>
</div>
```

### Form Layout
```html
<form class="space-y-6">
  <div>
    <label class="block text-sm font-medium text-gray-700 mb-2">
      System Name
    </label>
    <input 
      type="text" 
      class="form-input-flexlink w-full"
      placeholder="Enter system name"
    >
  </div>
  <div class="flex justify-end space-x-4">
    <button type="button" class="btn-flexlink-secondary">
      Cancel
    </button>
    <button type="submit" class="btn-flexlink-primary">
      Save Configuration
    </button>
  </div>
</form>
```

## Best Practices

### 1. Use Custom Classes for Common Patterns
- Use `btn-flexlink-primary` instead of recreating button styles
- Use `card-flexlink` for consistent card styling
- Use `panel-flexlink` for gradient panels

### 2. Leverage FlexLink Colors
- Use `text-flexlink-red` for primary text
- Use `bg-flexlink-red` for primary backgrounds
- Use `border-flexlink-red` for primary borders

### 3. Responsive Design
- Always use responsive prefixes (`md:`, `lg:`, `xl:`)
- Test on multiple screen sizes
- Use mobile-first approach

### 4. Accessibility
- Maintain proper color contrast ratios
- Use semantic HTML elements
- Include proper focus states

### 5. Performance
- Use utility classes over custom CSS when possible
- Minimize custom CSS to essential overrides only
- Use Tailwind's purge feature in production

## Migration from Vanilla CSS

### Before (Vanilla CSS)
```css
.stat-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  border: 1px solid #F5F5F5;
}
```

### After (Tailwind)
```html
<div class="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
  <!-- Content -->
</div>
```

### Or Using Custom Component Class
```html
<div class="card-flexlink">
  <!-- Content -->
</div>
```

## Troubleshooting

### 1. Colors Not Working
- Ensure Tailwind config is properly loaded
- Check that color names match the config
- Verify CSS is being compiled correctly

### 2. Gradients Not Showing
- Check browser support for CSS gradients
- Verify gradient syntax in config
- Test with different browsers

### 3. Animations Not Working
- Ensure animation classes are defined in config
- Check for CSS conflicts
- Verify browser support

### 4. Build Issues
- Run `npm install` to ensure dependencies
- Check Node.js version compatibility
- Verify PostCSS configuration

## Future Enhancements

### 1. Dark Mode Support
```javascript
// In tailwind.config.js
darkMode: 'class',
```

### 2. Additional Color Variants
```javascript
// Add more color shades
'flexlink-red-50': '#fef2f2',
'flexlink-red-100': '#fee2e2',
// ... etc
```

### 3. Component Library
- Create more reusable component classes
- Document all component variations
- Build a design system guide

### 4. Performance Optimization
- Implement CSS purging for production
- Optimize bundle size
- Add critical CSS extraction 