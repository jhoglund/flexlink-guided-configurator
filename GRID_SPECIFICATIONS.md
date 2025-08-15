# FlexLink Grid System Specifications

## Overview
This document outlines the responsive grid system implemented for the FlexLink Guided Configurator, featuring dynamic gutters, responsive column counts, and adaptive horizontal margins across all breakpoints.

## Grid System Architecture

### Core Features
- **Dynamic Gutters**: Automatically scales between 12px-24px based on available space
- **Responsive Columns**: Adapts from 3 to 24 columns based on viewport size
- **Adaptive Margins**: 24px margins on small screens, 48px margins on medium+ screens
- **CSS Variables**: Uses CSS custom properties for dynamic calculations
- **No Circular Dependencies**: Optimized variable structure for performance

### Breakpoint System

| Breakpoint | Viewport Width | Columns | Gutter Range | Margins | Max Width |
|------------|----------------|---------|--------------|---------|-----------|
| **XS** | < 332px | 3 | 12px (fixed) | 24px (12px each side) | Unlimited |
| **S** | ≥ 332px | 6 | 12px (fixed) | 24px (12px each side) | Unlimited |
| **M** | ≥ 628px | 12 | 12px-24px (dynamic) | 48px (24px each side) | Unlimited |
| **L** | ≥ 1220px | 24 | 12px-24px (dynamic) | 48px (24px each side) | 1512px |

## CSS Implementation

### Core Variables
```css
:root {
    --cols: 3;                    /* Default column count */
    --gutter: 12px;              /* Default gutter width */
    --grid-max: 99999px;         /* Maximum grid width */
    --grid-width: calc(min(100vw - 48px, var(--grid-max)));  /* 24px margins */
    --col: calc((var(--grid-width) - (var(--cols) - 1) * var(--gutter)) / var(--cols));
}
```

### Dynamic Gutter and Margin Calculation
```css
/* Medium breakpoint (12 columns, 48px margins) */
--grid-width: calc(min(100vw - 96px, var(--grid-max)));  /* 48px margins */
--gutter: clamp(12px, calc((var(--grid-width) - 62px * var(--cols)) / (var(--cols) - 1)), 24px);

/* Large breakpoint (24 columns, 48px margins) */
--grid-width: calc(min(100vw - 96px, var(--grid-max)));  /* 48px margins */
--gutter: clamp(12px, calc((min(100vw - 96px, 1512px) - 24 * 40px) / 23), 24px);
```

### Margin System Benefits
- **Small screens (XS, S)**: 24px margins for space efficiency
- **Medium+ screens (M, L)**: 48px margins for better visual hierarchy
- **Professional appearance**: Generous whitespace on larger screens
- **Better readability**: Improved content focus and scanning

## Grid Classes

### Container Classes
```css
.grid-container    /* Main grid container with dynamic width */
.grid             /* Grid layout with responsive columns and gutters */
```

### Column Span Classes

#### Base Classes (XS breakpoint)
```css
.col-span-1       /* Span 1 column */
.col-span-2       /* Span 2 columns */
.col-span-3       /* Span 3 columns */
/* ... through .col-span-24 */
.col-span-full    /* Span all available columns */
```

#### Responsive Classes
```css
/* Small breakpoint (≥332px, 6 columns) */
.sm\:col-span-1  /* Span 1 column at small+ */
.sm\:col-span-2  /* Span 2 columns at small+ */
/* ... through .sm\:col-span-24 */

/* Medium breakpoint (≥628px, 12 columns) */
.md\:col-span-1  /* Span 1 column at medium+ */
.md\:col-span-2  /* Span 2 columns at medium+ */
/* ... through .md\:col-span-24 */

/* Large breakpoint (≥1220px, 24 columns) */
.lg\:col-span-1  /* Span 1 column at large+ */
.lg\:col-span-2  /* Span 2 columns at large+ */
/* ... through .lg\:col-span-24 */
```

## Usage Examples

### Basic Grid Layout
```html
<div class="grid-container">
  <div class="grid">
    <!-- Full width content -->
    <div class="col-span-full">Header</div>
    
    <!-- Responsive sidebar + content -->
    <div class="col-span-full md:col-span-4 lg:col-span-6">Sidebar</div>
    <div class="col-span-full md:col-span-8 lg:col-span-18">Main Content</div>
    
    <!-- Responsive card grid -->
    <div class="col-span-3 sm:col-span-2 md:col-span-3 lg:col-span-6">Card 1</div>
    <div class="col-span-3 sm:col-span-2 md:col-span-3 lg:col-span-6">Card 2</div>
    <div class="col-span-3 sm:col-span-2 md:col-span-3 lg:col-span-6">Card 3</div>
    <div class="col-span-3 sm:col-span-2 md:col-span-3 lg:col-span-6">Card 4</div>
  </div>
</div>
```

### Industry Categories Grid
```html
<div class="grid">
  <% @categories.each do |category| %>
    <div class="col-span-3 sm:col-span-2 md:col-span-3 lg:col-span-6">
      <!-- Category content -->
    </div>
  <% end %>
</div>
```

### Hero Section with Responsive Layout
```html
<div class="grid">
  <div class="col-span-12 md:col-span-6 lg:col-span-8">
    <h1>Welcome to FlexLink</h1>
    <p>Your content here</p>
  </div>
</div>
```

## Key Benefits

### 1. **Dynamic Gutters**
- Automatically scales between 12px-24px
- Maintains visual balance at all viewport sizes
- No manual gutter calculations needed

### 2. **Adaptive Margins**
- 24px margins on small screens for space efficiency
- 48px margins on medium+ screens for professional appearance
- Better visual hierarchy and content focus
- Generous whitespace on larger screens

### 3. **Responsive Design**
- 3 columns on mobile, 24 on large screens
- Smooth transitions between breakpoints
- Optimized for all device sizes
- Earlier breakpoint activation with 48px margins

### 4. **Performance**
- CSS variables for dynamic calculations
- No JavaScript required
- Efficient rendering and updates

### 5. **Maintainability**
- Consistent naming convention
- Clear breakpoint system
- Easy to extend and modify

## Browser Support
- **Modern browsers**: Full support for CSS Grid and CSS Variables
- **CSS Grid**: Required for grid layout functionality
- **CSS Variables**: Required for dynamic gutter calculations
- **Fallback**: Graceful degradation for older browsers

## Files and Dependencies

### Core Files
- `app/assets/stylesheets/grid.css` - Main grid system implementation
- `app/assets/stylesheets/variables.css` - CSS custom properties
- `app/assets/stylesheets/application.css` - Grid container styles

### Integration
- **Rails Asset Pipeline**: Automatic compilation and caching
- **No build tools required**: Pure vanilla CSS
- **Responsive design**: Mobile-first approach

## Testing and Debug

### Debug Grid Overlay
```css
body.debug-grid::before {
    /* Visual grid overlay for development */
    background-image: repeating-linear-gradient(to right,
        rgba(59, 130, 246, 0.2) 0 var(--col),
        rgba(156, 163, 175, 0.2) var(--col) var(--dbg-cycle));
}
```

### Grid Test Page
- **URL**: `/grid_test`
- **Purpose**: Visual testing of grid system
- **Features**: Breakpoint indicators, column visualization

## Best Practices

### 1. **Always use .grid-container**
```html
<!-- ✅ Correct -->
<div class="grid-container">
  <div class="grid">
    <!-- Grid content -->
  </div>
</div>

<!-- ❌ Incorrect -->
<div class="grid">
  <!-- Missing container -->
</div>
```

### 2. **Use responsive classes for flexibility**
```html
<!-- ✅ Responsive design -->
<div class="col-span-12 md:col-span-6 lg:col-span-8">

<!-- ❌ Fixed width -->
<div class="col-span-8">
```

### 3. **Plan for all breakpoints**
```html
<!-- ✅ Complete responsive coverage -->
<div class="col-span-3 sm:col-span-2 md:col-span-3 lg:col-span-6">

<!-- ❌ Missing breakpoints -->
<div class="col-span-3">
```

## Migration from Old System

### Old Classes → New Classes
```css
.grid-span-1     → .col-span-1
.grid-span-s-3   → .sm\:col-span-3
.grid-span-m-6   → .md\:col-span-6
.grid-span-l-12  → .lg\:col-span-12
.grid-span-full  → .col-span-full
```

### Container Updates
```css
.container       → .grid-container
.grid-item      → .grid
```

## Performance Considerations

### CSS Variable Optimization
- Variables calculated once per breakpoint
- No runtime JavaScript calculations
- Efficient browser rendering

### Asset Pipeline
- Automatic CSS compilation
- Gzip compression for production
- Browser caching optimization

## Future Enhancements

### Planned Features
- **Custom breakpoints**: User-defined breakpoint values
- **Grid templates**: Predefined layout patterns
- **Animation support**: Smooth transitions between states
- **Accessibility**: Enhanced screen reader support

### Extension Points
- **Additional breakpoints**: XS, XL, XXL
- **Grid patterns**: Masonry, masonry-grid layouts
- **Theme integration**: Dynamic color schemes
- **Component library**: Reusable grid components

---

*Last updated: August 2024*  
*Grid system version: 2.1*  
*Maintainer: FlexLink Development Team*  
*Features: Dynamic gutters, adaptive margins (24px/48px), responsive columns* 