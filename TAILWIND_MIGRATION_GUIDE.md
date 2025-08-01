# Tailwind CSS Migration Guide

## Overview
This document outlines the migration from vanilla CSS to Tailwind CSS utility classes for the FlexLink Configurator application.

## Migration Status

### ✅ Completed Files
- `app/assets/stylesheets/application.css` - Converted to minimal CSS with only essential overrides
- `app/views/layouts/application.html.erb` - Already using Tailwind
- `app/views/home/index.html.erb` - Converted to Tailwind utilities
- `app/views/configurations/index.html.erb` - Converted from Bootstrap to Tailwind
- `app/views/wizard/steps/_wizard_header.html.erb` - Converted to Tailwind utilities
- `app/views/wizard/steps/step_1.html.erb` - Converted to Tailwind utilities
- `app/views/wizard/steps/step_3.html.erb` - Converted to Tailwind utilities

### 🔄 Remaining Files to Convert
- `app/views/wizard/steps/step_2.html.erb`
- `app/views/wizard/steps/step_4.html.erb`
- `app/views/wizard/steps/step_5.html.erb`
- `app/views/wizard/steps/step_6.html.erb`
- `app/views/wizard/steps/step_7.html.erb`
- `app/views/wizard/steps/step_8.html.erb`
- `app/views/products/index.html.erb`
- `app/views/products/show.html.erb`
- `app/views/systems/index.html.erb` (if exists)

## Migration Patterns

### 1. Layout & Container Classes
```css
/* Old CSS */
.wizard-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

/* New Tailwind */
<div class="max-w-6xl mx-auto p-5">
```

### 2. Grid Systems
```css
/* Old CSS */
.dashboard-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
}

/* New Tailwind */
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
```

### 3. Card Components
```css
/* Old CSS */
.stat-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  border: 1px solid #F5F5F5;
}

/* New Tailwind */
<div class="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
```

### 4. Button Styles
```css
/* Old CSS */
.btn-primary {
  background: #8B2635;
  color: white;
  padding: 12px 24px;
  border-radius: 8px;
  font-weight: 500;
}

/* New Tailwind */
<button class="bg-red-600 text-white px-6 py-3 rounded-lg font-medium">
```

### 5. Form Elements
```css
/* Old CSS */
.form-input {
  border: 1px solid #F5F5F5;
  border-radius: 4px;
  padding: 8px 12px;
}

/* New Tailwind */
<input class="border border-gray-200 rounded px-3 py-2">
```

### 6. Typography
```css
/* Old CSS */
h1 {
  color: #2c3e50;
  font-size: 32px;
  font-weight: 600;
}

/* New Tailwind */
<h1 class="text-4xl font-bold text-gray-900">
```

### 7. Flexbox Layouts
```css
/* Old CSS */
.action-buttons {
  display: flex;
  justify-content: center;
  gap: 15px;
}

/* New Tailwind */
<div class="flex justify-center gap-4">
```

### 8. Hover States
```css
/* Old CSS */
.btn-primary:hover {
  background: #6B1E2A;
  transform: translateY(-1px);
}

/* New Tailwind */
<button class="bg-red-600 hover:bg-red-700 hover:transform hover:-translate-y-0.5 transition-all duration-200">
```

### 9. Responsive Design
```css
/* Old CSS */
@media (max-width: 768px) {
  .dashboard-actions {
    grid-template-columns: 1fr;
  }
}

/* New Tailwind */
<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
```

### 10. Custom Gradients
```css
/* Old CSS */
.panel-gradient {
  background: var(--flexlink-radial-gradient);
  color: white;
}

/* New Tailwind */
<div class="bg-radial-gradient text-white">
```

## Color Scheme Mapping

### FlexLink Brand Colors
- Primary Red: `#8B2635` → `red-600`
- Dark Red: `#6B1E2A` → `red-700`
- Black: `#000000` → `gray-900`
- White: `#FFFFFF` → `white`
- Dark Gray: `#4A4A4A` → `gray-600`
- Light Gray: `#F5F5F5` → `gray-100`
- Medium Gray: `#808080` → `gray-500`

### Status Colors
- Success: `green-500`, `green-100`, `green-800`
- Warning: `yellow-500`, `yellow-100`, `yellow-800`
- Error: `red-500`, `red-100`, `red-800`
- Info: `blue-500`, `blue-100`, `blue-800`

## Common Utility Classes

### Spacing
- `p-5` = padding: 1.25rem
- `px-6` = padding-left/right: 1.5rem
- `py-3` = padding-top/bottom: 0.75rem
- `m-4` = margin: 1rem
- `mb-8` = margin-bottom: 2rem
- `gap-6` = gap: 1.5rem

### Typography
- `text-lg` = font-size: 1.125rem
- `text-2xl` = font-size: 1.5rem
- `font-semibold` = font-weight: 600
- `text-gray-900` = color: #111827
- `text-center` = text-align: center

### Layout
- `flex` = display: flex
- `grid` = display: grid
- `hidden` = display: none
- `block` = display: block
- `inline-block` = display: inline-block

### Positioning
- `relative` = position: relative
- `absolute` = position: absolute
- `fixed` = position: fixed
- `top-0` = top: 0
- `left-0` = left: 0

### Borders & Shadows
- `rounded-lg` = border-radius: 0.5rem
- `border` = border-width: 1px
- `border-gray-200` = border-color: #e5e7eb
- `shadow-sm` = box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05)
- `shadow-lg` = box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1)

### Transitions
- `transition-colors` = transition-property: color, background-color, border-color, text-decoration-color, fill, stroke
- `transition-all` = transition-property: all
- `duration-200` = transition-duration: 200ms
- `duration-300` = transition-duration: 300ms

## Migration Checklist

For each remaining file:

1. **Replace Container Classes**
   - `wizard-container` → `max-w-6xl mx-auto p-5`
   - `dashboard-container` → `py-5`

2. **Convert Grid Systems**
   - Bootstrap `row` → `grid`
   - Bootstrap `col-md-8` → `lg:col-span-8`
   - Custom grids → `grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3`

3. **Update Card Components**
   - `card` → `bg-white rounded-lg shadow-sm border border-gray-200`
   - `card-header` → `px-6 py-4 border-b border-gray-200`
   - `card-body` → `p-6`

4. **Convert Buttons**
   - `btn btn-primary` → `bg-red-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-red-700`
   - `btn btn-secondary` → `bg-gray-200 text-gray-700 px-6 py-3 rounded-lg font-medium hover:bg-gray-300`

5. **Update Typography**
   - `h1`, `h2`, `h3` → `text-2xl`, `text-xl`, `text-lg font-bold text-gray-900`
   - `text-muted` → `text-gray-500`
   - `text-primary` → `text-red-600`

6. **Convert Tables**
   - Bootstrap table classes → Tailwind table utilities
   - `table-responsive` → `overflow-x-auto`
   - `table-hover` → `hover:bg-gray-50`

7. **Update Forms**
   - `form-control` → `border border-gray-200 rounded px-3 py-2`
   - `form-input` → `border border-gray-200 rounded px-3 py-2`

8. **Convert Alerts**
   - Bootstrap alert classes → Tailwind alert utilities
   - `alert-success` → `bg-green-50 border border-green-200 text-green-700`
   - `alert-danger` → `bg-red-50 border border-red-200 text-red-700`

## Benefits of Migration

1. **Consistency**: All styling uses the same design system
2. **Maintainability**: No custom CSS to maintain
3. **Performance**: Smaller CSS bundle size
4. **Responsive**: Built-in responsive utilities
5. **Developer Experience**: Faster development with utility classes

## Testing After Migration

1. **Visual Regression**: Compare before/after screenshots
2. **Responsive Testing**: Test on mobile, tablet, desktop
3. **Interactive Elements**: Test hover states, transitions
4. **Accessibility**: Ensure color contrast and focus states
5. **Cross-browser**: Test in Chrome, Firefox, Safari, Edge

## Next Steps

1. Complete migration of remaining wizard steps
2. Convert product views
3. Update any remaining Bootstrap components
4. Remove unused CSS files
5. Update documentation with new class patterns
6. Train team on Tailwind utility approach 