# 🔧 Render Deployment Troubleshooting Guide

## Current Status
- ✅ Database (PostgreSQL) - Created successfully
- ✅ Redis - Created successfully  
- ❌ Web Service - Failed to deploy

## Common Causes & Solutions

### 1. **Missing Environment Variables**
The most common cause of deployment failure is missing environment variables.

**Required Variables in Render:**
```
RAILS_MASTER_KEY=1b145e7beedbf6ccaf05d938f0eafbaa
SUPABASE_URL=https://vpgawhkvfibhzafkdcsa.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZwZ2F3aGt2ZmliaHphZmtkY3NhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM3Nzk0NjAsImV4cCI6MjA2OTM1NTQ2MH0.QjGdS6_Y4Dkud1E2wGBI11UE1UXljvMW5v0FQm1tJmc
```

**Steps to fix:**
1. Go to your web service in Render dashboard
2. Click "Environment" tab
3. Add the missing variables above
4. Redeploy

### 2. **Build Script Issues**
The build script has been updated to be more robust.

**Check build logs:**
1. Go to your web service in Render
2. Click "Logs" tab
3. Look for error messages in the build phase

### 3. **Ruby Version Issues**
- Current: Ruby 3.3.1
- Render supports this version

### 4. **Asset Compilation Issues**
If assets fail to compile, try:
```bash
# Locally test asset compilation
RAILS_ENV=production bundle exec rake assets:precompile
```

### 5. **Database Connection Issues**
The web service needs to connect to the PostgreSQL database.

**Check:**
- `DATABASE_URL` is automatically set by render.yaml
- Database migrations run successfully

## Debugging Steps

### Step 1: Check Build Logs
1. Go to Render dashboard
2. Click on your web service
3. Go to "Logs" tab
4. Look for error messages during build

### Step 2: Check Runtime Logs
1. After build completes, check runtime logs
2. Look for application startup errors

### Step 3: Verify Environment Variables
1. Go to web service settings
2. Check "Environment" tab
3. Ensure all required variables are set

### Step 4: Test Locally
```bash
# Test production build locally
RAILS_ENV=production bundle install
RAILS_ENV=production bundle exec rake assets:precompile
RAILS_ENV=production bundle exec rake db:migrate
```

## Quick Fixes to Try

### Fix 1: Add Missing Environment Variables
Add these to your web service environment variables in Render:
- `RAILS_MASTER_KEY`
- `SUPABASE_URL` 
- `SUPABASE_ANON_KEY`

### Fix 2: Manual Redeploy
1. Go to web service in Render
2. Click "Manual Deploy"
3. Watch the build logs for errors

### Fix 3: Check Ruby Version
Ensure Render is using Ruby 3.3.1 (should be automatic)

## Common Error Messages

### "Asset compilation failed"
- Check if all JavaScript/CSS files are valid
- Ensure all dependencies are in Gemfile

### "Database connection failed"
- Check if DATABASE_URL is set correctly
- Verify PostgreSQL service is running

### "Master key not found"
- Ensure RAILS_MASTER_KEY is set in environment variables

### "Missing environment variable"
- Add the missing variable to Render environment settings

## Next Steps

1. **Check the build logs** in Render dashboard
2. **Add missing environment variables** if needed
3. **Try manual redeploy**
4. **Contact support** if issues persist

## Support Resources

- **Render Documentation**: [docs.render.com](https://docs.render.com)
- **Rails Deployment Guide**: [guides.rubyonrails.org/deployment.html](https://guides.rubyonrails.org/deployment.html)
- **Render Community**: [community.render.com](https://community.render.com) 