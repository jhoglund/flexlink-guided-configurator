# Font Files

This directory should contain the DIN and Rotis font files for the FlexLink Configurator application.

## DIN Font Files

## Required Font Files

Place the following font files in this directory:

### Regular Weight (400)
- `DIN-Regular.woff2` (preferred - smallest file size)
- `DIN-Regular.woff` (fallback)
- `DIN-Regular.ttf` (fallback)

### Medium Weight (500)
- `DIN-Medium.woff2` (preferred)
- `DIN-Medium.woff` (fallback)
- `DIN-Medium.ttf` (fallback)

### Bold Weight (700)
- `DIN-Bold.woff2` (preferred)
- `DIN-Bold.woff` (fallback)
- `DIN-Bold.ttf` (fallback)

### Italic Styles
- `DIN-Italic.woff2` (Regular italic)
- `DIN-Italic.woff` (Regular italic fallback)
- `DIN-Italic.ttf` (Regular italic fallback)
- `DIN-BoldItalic.woff2` (Bold italic)
- `DIN-BoldItalic.woff` (Bold italic fallback)
- `DIN-BoldItalic.ttf` (Bold italic fallback)
- `DIN-MediumItalic.woff2` (Medium italic)
- `DIN-MediumItalic.woff` (Medium italic fallback)
- `DIN-MediumItalic.ttf` (Medium italic fallback)

## Font Sources

DIN is a proprietary font family. You can obtain the font files from:

- **Linotype/Monotype**: https://www.linotype.com/
- **Adobe Fonts**: https://fonts.adobe.com/
- **Other authorized font distributors**

## Rotis Font Files

### Required Font Files

Place the following Rotis font files in this directory:

### Regular Weight (400)
- `Rotis-Regular.woff2` (preferred - smallest file size)
- `Rotis-Regular.woff` (fallback)
- `Rotis-Regular.ttf` (fallback)

### Medium Weight (500)
- `Rotis-Medium.woff2` (preferred)
- `Rotis-Medium.woff` (fallback)
- `Rotis-Medium.ttf` (fallback)

### Bold Weight (700)
- `Rotis-Bold.woff2` (preferred)
- `Rotis-Bold.woff` (fallback)
- `Rotis-Bold.ttf` (fallback)

### Italic Styles
- `Rotis-Italic.woff2` (Regular italic)
- `Rotis-Italic.woff` (Regular italic fallback)
- `Rotis-Italic.ttf` (Regular italic fallback)
- `Rotis-BoldItalic.woff2` (Bold italic)
- `Rotis-BoldItalic.woff` (Bold italic fallback)
- `Rotis-BoldItalic.ttf` (Bold italic fallback)
- `Rotis-MediumItalic.woff2` (Medium italic)
- `Rotis-MediumItalic.woff` (Medium italic fallback)
- `Rotis-MediumItalic.ttf` (Medium italic fallback)

### Rotis Font Sources

Rotis is a proprietary font family. You can obtain the font files from:

- **Monotype**: https://www.monotype.com/
- **Adobe Fonts**: https://fonts.adobe.com/
- **Other authorized font distributors**

## Usage

Once the font files are placed in this directory, the application will automatically use DIN as the default font family. The font is configured in:

- `app/assets/stylesheets/fonts.css` - Font declarations
- `app/assets/stylesheets/application.css` - Font import
- `tailwind.config.js` - Default font family configuration

## CSS Classes

The following Tailwind classes are available for font weights:

- `font-normal` (400) - DIN Regular
- `font-medium` (500) - DIN Medium  
- `font-bold` (700) - DIN Bold
- `italic` - Italic style
- `font-din` - Explicit DIN font family class

## Testing

After adding the font files, restart your development server and check that the font is loading correctly by inspecting the page in your browser's developer tools. 