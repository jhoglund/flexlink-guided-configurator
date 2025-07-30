// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript (and CoffeeScript if configured) file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require_tree .
//= require_self

// FlexLink Configurator JavaScript
document.addEventListener('DOMContentLoaded', function () {
    // Initialize any global JavaScript functionality
    console.log('FlexLink Configurator loaded successfully!');

    // Auto-hide flash messages after 5 seconds
    setTimeout(function () {
        const flashMessages = document.querySelectorAll('.alert');
        flashMessages.forEach(function (message) {
            message.style.opacity = '0';
            setTimeout(function () {
                message.remove();
            }, 300);
        });
    }, 5000);

    // Initialize Bootstrap tooltips if available
    if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    }
}); 