/** @type {import('tailwindcss').Config} */
module.exports = {
    content: [
        './app/views/**/*.erb',
        './app/views/*.erb',
        './app/helpers/**/*.rb',
        './app/javascript/**/*.js',
        './app/assets/stylesheets/**/*.css',
        './config/initializers/simple_form.rb',
        './lib/tasks/**/*.rake',
        './vendor/bundle/**/*/lib/**/*.rb'
    ],
    theme: {
        extend: {
            colors: {
                'flexlink': {
                    'red': '#D70A32',      // Primary FlexLink red
                    'red-dark': '#6B1E2A',  // Darker red for hover states
                    'red-light': '#D70A32', // Bright red from gradient start
                    'red-deep': '#A10221',  // Deep red from gradient end
                    'black': '#000000',     // Pure black
                    'white': '#FFFFFF',     // Pure white
                    'dark-gray': '#4A4A4A', // Dark gray from swatch
                    'light-gray': '#F5F5F5', // Light gray from swatch
                    'medium-gray': '#808080' // Medium gray from swatch
                }
            },
            backgroundImage: {
                'radial-gradient': 'radial-gradient(circle, #D70A32 0%, #A10221 88%)',
                'radial-gradient-reverse': 'radial-gradient(circle, #A10221 0%, #D70A32 88%)',
                'radial-gradient-soft': 'radial-gradient(circle at center, #D70A32 0%, rgba(161, 2, 33, 0.8) 88%)',
                'gradient-primary': 'linear-gradient(135deg, #8B2635 0%, #6B1E2A 100%)',
                'gradient-secondary': 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
            },
            fontFamily: {
                'sans': [
                    'DIN',
                    'Rotis',
                    'Inter',
                    '-apple-system',
                    'BlinkMacSystemFont',
                    '"Segoe UI"',
                    'Roboto',
                    '"Helvetica Neue"',
                    'Arial',
                    'sans-serif'
                ],
                'din': ['DIN', 'Rotis', 'Inter', 'sans-serif']
            },
            spacing: {
                '18': '4.5rem',
                '88': '22rem',
                '128': '32rem',
                '200': '50rem', // 200px margin from Figma specs
                '24': '6rem'    // 24px gutter from Figma specs
            },
            borderRadius: {
                'xl': '0.75rem',
                '2xl': '1rem',
                '3xl': '1.5rem'
            },
            boxShadow: {
                'flexlink': '0 4px 20px rgba(139, 38, 53, 0.2)',
                'flexlink-lg': '0 10px 30px rgba(139, 38, 53, 0.3)',
                'flexlink-xl': '0 20px 40px rgba(139, 38, 53, 0.4)'
            },
            animation: {
                'fade-in': 'fadeIn 0.5s ease-in-out',
                'slide-up': 'slideUp 0.3s ease-out',
                'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite'
            },
            keyframes: {
                fadeIn: {
                    '0%': { opacity: '0' },
                    '100%': { opacity: '1' }
                },
                slideUp: {
                    '0%': { transform: 'translateY(10px)', opacity: '0' },
                    '100%': { transform: 'translateY(0)', opacity: '1' }
                }
            },

        }
    },
    safelist: [
        'col-span-4',
        'md:col-span-2'
    ],
    plugins: [
        require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),
        require('@tailwindcss/aspect-ratio')
    ]
} 