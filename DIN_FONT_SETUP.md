# Font Setup Guide

This guide explains how to complete the DIN and Rotis font setup for the FlexLink Configurator application.

## What's Been Set Up

The following files have been created/updated to support DIN font:

### 1. Font Directory Structure
- `app/assets/fonts/` - Directory for font files
- `app/assets/fonts/README.md` - Instructions for adding font files
- `app/assets/fonts/.gitkeep` - Ensures directory is tracked in git

### 2. CSS Font Declarations
- `app/assets/stylesheets/fonts.css` - Contains all @font-face declarations for DIN
- `app/assets/stylesheets/rotis-fonts.css` - Contains all @font-face declarations for Rotis
- Supports Regular (400), Medium (500), Bold (700) weights for both fonts
- Supports Normal and Italic styles for each weight
- Uses font-display: swap for better performance

### 3. Application Integration
- `app/assets/stylesheets/application.css` - Imports both fonts.css and rotis-fonts.css files
- `tailwind.config.js` - Updated to use DIN as primary font with Rotis and Inter as fallbacks
- Added Google Fonts link for Inter as web-available fallback
- Added fallback fonts for better compatibility

### 4. Testing
- Added font test section to home page (`app/views/home/index.html.erb`)
- Tests all font weights and styles
- Can be removed after confirming fonts work

## Next Steps

### 1. Obtain Font Files
You need to purchase or obtain the DIN and Rotis font files from authorized sources:

**⚠️ Note**: Font files are not included in the repository due to licensing restrictions. You must obtain them separately.

**DIN Font Sources:**
- **Linotype/Monotype**: https://www.linotype.com/
- **Adobe Fonts**: https://fonts.adobe.com/
- **FontShop**: https://www.fontshop.com/

**Rotis Font Sources:**
- **Monotype**: https://www.monotype.com/
- **Adobe Fonts**: https://fonts.adobe.com/
- **Other authorized font distributors**

**Required Files:**
```
app/assets/fonts/
├── DIN-Regular.woff2
├── DIN-Regular.woff
├── DIN-Regular.ttf
├── DIN-Medium.woff2
├── DIN-Medium.woff
├── DIN-Medium.ttf
├── DIN-Bold.woff2
├── DIN-Bold.woff
├── DIN-Bold.ttf
├── DIN-Italic.woff2
├── DIN-Italic.woff
├── DIN-Italic.ttf
├── DIN-BoldItalic.woff2
├── DIN-BoldItalic.woff
├── DIN-BoldItalic.ttf
├── DIN-MediumItalic.woff2
├── DIN-MediumItalic.woff
├── DIN-MediumItalic.ttf
├── Rotis-Regular.woff2
├── Rotis-Regular.woff
├── Rotis-Regular.ttf
├── Rotis-Medium.woff2
├── Rotis-Medium.woff
├── Rotis-Medium.ttf
├── Rotis-Bold.woff2
├── Rotis-Bold.woff
├── Rotis-Bold.ttf
├── Rotis-Italic.woff2
├── Rotis-Italic.woff
├── Rotis-Italic.ttf
├── Rotis-BoldItalic.woff2
├── Rotis-BoldItalic.woff
├── Rotis-BoldItalic.ttf
├── Rotis-MediumItalic.woff2
├── Rotis-MediumItalic.woff
└── Rotis-MediumItalic.ttf
```

### 2. Add Font Files
1. Place all DIN and Rotis font files in `app/assets/fonts/`
2. Remove `app/assets/fonts/.gitkeep` file
3. Restart your development server

### 3. Test the Implementation
1. Start your development server: `./start_dev.sh`
2. Navigate to the home page
3. Check the "DIN Font Test" section
4. Verify all font weights and styles display correctly
5. Use browser developer tools to confirm fonts are loading

### 4. Clean Up
1. Remove the font test section from `app/views/home/index.html.erb` (after confirming fonts work)
2. Remove `app/assets/fonts/README.md` (optional)
3. Update `app/assets/fonts/README.md` with your specific font file information

## Font Usage

Once implemented, DIN will be the primary font with Rotis and Inter as fallbacks throughout the application:

### Tailwind Classes Available:
- `font-normal` (400) - DIN Regular
- `font-medium` (500) - DIN Medium
- `font-bold` (700) - DIN Bold
- `italic` - Italic style
- `font-din` - Explicit DIN font family

### CSS Classes:
```css
/* Regular weight */
font-family: 'DIN', 'Rotis', 'Inter', sans-serif;
font-weight: 400;

/* Medium weight */
font-weight: 500;

/* Bold weight */
font-weight: 700;

/* Italic styles */
font-style: italic;
```

## Troubleshooting

### Font Not Loading
1. Check browser developer tools → Network tab
2. Verify font files are in correct location
3. Check file permissions
4. Clear browser cache

### Font Not Displaying
1. Check browser developer tools → Elements tab
2. Verify font-family is set to 'DIN'
3. Check if fallback fonts are being used

### Performance Issues
1. Ensure .woff2 files are used (smallest size)
2. Check font-display: swap is working
3. Consider font preloading for critical fonts

## License Compliance

Remember that DIN is a proprietary font. Ensure you have proper licensing for:
- Web font usage
- Number of domains/websites
- Commercial use rights

## Support

If you encounter issues:
1. Check the browser console for errors
2. Verify all font files are present
3. Test with different browsers
4. Check font loading in browser developer tools 