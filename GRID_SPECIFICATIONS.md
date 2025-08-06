# FlexLink Grid System Specifications

## Overview
This document outlines the responsive grid system specifications implemented based on the Figma design for the FlexLink Online Store.

## Grid Specifications

### Core Specifications
- **Columns:** 12
- **Margin:** 200px (left and right)
- **Gutter:** 24px
- **Grid Color:** #870101 (red) with 7% opacity
- **Type:** Stretch (auto-width columns)
- **Width:** Auto

### Implementation Details

#### CSS Classes Available
- `.grid-figma` - Main grid container with 12 columns
- `.col-figma-1` through `.col-figma-12` - Column span classes

#### Grid Features
1. **12-Column Layout:** Each row is divided into 12 equal columns
2. **Responsive Margins:** 200px margins on desktop, scaling down on mobile
3. **24px Gutters:** Consistent spacing between grid items
4. **Visual Grid Lines:** Red grid lines (#870101) with 7% opacity for design reference
5. **Auto-Width Columns:** Columns stretch to fill available space

#### Responsive Behavior
- **Desktop (>768px):** 200px margins, 24px gutters, 12 columns
- **Tablet (≤768px):** 20px margins, 16px gutters, 6 columns
- **Mobile (≤480px):** 10px margins, 12px gutters, 4 columns

#### Usage Example
```html
<div class="grid-figma">
  <div class="col-figma-12">Full width content</div>
  <div class="col-figma-6">Half width content</div>
  <div class="col-figma-6">Half width content</div>
  <div class="col-figma-4">One-third width</div>
  <div class="col-figma-4">One-third width</div>
  <div class="col-figma-4">One-third width</div>
</div>
```

## Visual Grid System
The grid system includes visual grid lines that match the Figma specifications:
- Red color (#870101) with 7% opacity
- Vertical lines dividing the 12 columns
- Horizontal lines at 24px intervals
- Non-interactive overlay for design reference

## Integration with Tailwind CSS
The grid system is built on top of Tailwind CSS and includes:
- Custom spacing values for margins and gutters
- Custom grid template columns
- Custom grid column span utilities
- Responsive breakpoints for mobile optimization

## Browser Support
- Modern browsers with CSS Grid support
- Graceful degradation for older browsers
- Mobile-first responsive design

## Files Modified
- `tailwind.config.js` - Added custom grid utilities and spacing
- `app/assets/stylesheets/application.css` - Added Figma grid system CSS
- `app/views/home/index.html.erb` - Updated to use new grid system

## Testing
The grid system has been implemented and tested on the home page with various column layouts to demonstrate the 12-column system with the specified margins and gutters. 