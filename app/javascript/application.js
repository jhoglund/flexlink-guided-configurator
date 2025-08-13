// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Debug Grid Overlay Toggle
document.addEventListener('DOMContentLoaded', function () {
    console.log('Debug Grid: DOM Content Loaded');

    try {
        // Create debug toggle button
        const debugToggle = document.createElement('button');
        debugToggle.className = 'debug-toggle';
        debugToggle.textContent = 'Grid';
        debugToggle.title = 'Toggle 12-column grid overlay (G key)';

        // Create debug info panel
        const debugInfo = document.createElement('div');
        debugInfo.className = 'debug-info';
        debugInfo.innerHTML = `
            <h4>Grid Debug Info</h4>
            <p>Grid: 12 columns</p>
            <p>Gutter: 24px</p>
            <p>XL Margin: 200px</p>
            <p>Press G to toggle</p>
        `;

        // Add to body
        document.body.appendChild(debugToggle);
        document.body.appendChild(debugInfo);

        console.log('Debug Grid: Button and info panel added to DOM');
        console.log('Debug Grid: Button element:', debugToggle);
        console.log('Debug Grid: Button computed styles:', window.getComputedStyle(debugToggle));

        // Toggle function
        function toggleGrid() {
            const body = document.body;
            const isActive = body.classList.contains('debug-grid');

            if (isActive) {
                body.classList.remove('debug-grid');
                debugToggle.classList.remove('active');
                debugToggle.textContent = 'Grid';
            } else {
                body.classList.add('debug-grid');
                debugToggle.classList.add('active');
                debugToggle.textContent = 'Hide';
            }

            console.log('Debug Grid: Toggled, active:', !isActive);
        }

        // Button click
        debugToggle.addEventListener('click', toggleGrid);

        // Keyboard shortcut (G key)
        document.addEventListener('keydown', function (e) {
            if (e.key === 'g' || e.key === 'G') {
                e.preventDefault();
                toggleGrid();
            }
        });

        // Show grid on specific elements (optional)
        function showGridOnElement(selector) {
            const element = document.querySelector(selector);
            if (element) {
                element.classList.add('debug-grid');
            }
        }

        // Example: Show grid on specific sections
        // showGridOnElement('.hero');
        // showGridOnElement('.industry-grid');

        console.log('Debug Grid: Setup complete');

    } catch (error) {
        console.error('Debug Grid: Error setting up grid overlay:', error);
    }
}); 