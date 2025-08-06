# Auto-Reload Guide

## Overview
The FlexLink Configurator includes auto-reload functionality using Guard and LiveReload. This allows you to see changes to your views, CSS, and JavaScript files immediately in the browser without manual refresh.

## How It Works
1. **Guard** watches for file changes in your Rails application
2. **LiveReload** automatically refreshes the browser when changes are detected
3. **Port 35729** is exposed for LiveReload communication

## Setup Instructions

### 1. Start the Development Environment
```bash
./bin/dev
```

This will start all services including:
- Rails web server (port 3000)
- PostgreSQL database
- Redis cache
- Guard with LiveReload (port 35729)

### 2. Install LiveReload Browser Extension
- **Chrome**: [LiveReload Extension](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei)
- **Firefox**: [LiveReload Extension](https://addons.mozilla.org/en-US/firefox/addon/livereload/)
- **Safari**: [LiveReload Extension](https://safari-extensions.apple.com/details/?id=com.andymatuschak.livereload-AGQH2LQ5K8)

### 3. Enable LiveReload
1. Open http://localhost:3000 in your browser
2. Click the LiveReload extension icon in your browser toolbar
3. Enable LiveReload for localhost:3000

## What Gets Auto-Reloaded
Guard watches for changes in:
- **Views**: `app/views/**/*.erb`
- **Helpers**: `app/helpers/**/*.rb`
- **Assets**: `app/assets/**/*.(css|js)`
- **Images**: `app/assets/images/**/*.(png|jpg|jpeg|gif|svg)`
- **Controllers**: `app/controllers/**/*.rb`
- **Models**: `app/models/**/*.rb`
- **Configuration**: `config/locales/**/*.yml`, `config/routes.rb`, `config/application.rb`
- **Layouts**: `app/views/layouts/**/*.erb`

## Troubleshooting

### Auto-reload not working?
1. **Check if Guard is running**:
   ```bash
   docker-compose -f docker-compose.dev.yml ps
   ```
   You should see the `guard` service running.

2. **Check Guard logs**:
   ```bash
   docker-compose -f docker-compose.dev.yml logs guard
   ```
   You should see "LiveReload is waiting for a browser to connect."

3. **Verify LiveReload extension is enabled**:
   - Check that the LiveReload extension icon shows as active
   - Ensure it's enabled for localhost:3000

4. **Restart Guard service**:
   ```bash
   docker-compose -f docker-compose.dev.yml restart guard
   ```

### Browser not connecting to LiveReload?
1. Make sure you're accessing the site via `http://localhost:3000` (not `127.0.0.1:3000`)
2. Check that port 35729 is accessible (no firewall blocking it)
3. Try disabling and re-enabling the LiveReload extension

## Manual Refresh Fallback
If auto-reload isn't working, you can always manually refresh your browser to see changes. The Rails server will automatically reload Ruby code changes, but you'll need to refresh for view/asset changes.

## Development Workflow
1. Start the development environment: `./bin/dev`
2. Open http://localhost:3000 in your browser
3. Enable LiveReload extension
4. Make changes to your files
5. See changes automatically in the browser!

## Stopping Auto-Reload
To stop the development environment:
```bash
docker-compose -f docker-compose.dev.yml down
```

Or press `Ctrl+C` in the terminal where you ran `./bin/dev`. 