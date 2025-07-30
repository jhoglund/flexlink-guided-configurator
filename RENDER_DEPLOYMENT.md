# Render Deployment Guide

This guide will walk you through deploying the FlexLink Guided Configurator to Render's free tier.

## Prerequisites

1. **GitHub Account**: Your code should be in a GitHub repository
2. **Render Account**: Sign up at [render.com](https://render.com)
3. **Environment Variables**: You'll need your Supabase credentials

## Step 1: Prepare Your Repository

Your repository should now include:
- `render.yaml` - Render configuration
- `bin/render-build.sh` - Build script
- `config/puma.rb` - Puma configuration
- Updated production configuration

## Step 2: Create a Render Account

1. Go to [render.com](https://render.com)
2. Click "Get Started for Free"
3. Sign up with your GitHub account (recommended)
4. Complete the verification process

## Step 3: Deploy Your Application

### Option A: Using render.yaml (Recommended)

1. **Connect your GitHub repository**:
   - In Render dashboard, click "New +"
   - Select "Blueprint"
   - Connect your GitHub account if not already connected
   - Select your repository
   - Render will automatically detect the `render.yaml` file

2. **Configure Environment Variables**:
   - You'll need to set these environment variables in Render:
     - `RAILS_MASTER_KEY` (from your `config/master.key` file)
     - `SUPABASE_URL` (your Supabase project URL)
     - `SUPABASE_ANON_KEY` (your Supabase anonymous key)

3. **Deploy**:
   - Click "Create Blueprint"
   - Render will create the web service, PostgreSQL database, and Redis instance
   - The first deployment will take 5-10 minutes

### Option B: Manual Setup

If you prefer to set up services manually:

1. **Create PostgreSQL Database**:
   - Go to "New +" → "PostgreSQL"
   - Name: `flexlink-postgres`
   - Plan: Free
   - Click "Create Database"

2. **Create Redis Instance**:
   - Go to "New +" → "Redis"
   - Name: `flexlink-redis`
   - Plan: Free
   - Click "Create Redis"

3. **Create Web Service**:
   - Go to "New +" → "Web Service"
   - Connect your GitHub repository
   - Configure:
     - **Name**: `flexlink-guided-configurator`
     - **Environment**: Ruby
     - **Build Command**: `./bin/render-build.sh`
     - **Start Command**: `bundle exec puma -C config/puma.rb`
     - **Plan**: Free

4. **Set Environment Variables**:
   ```
   RAILS_MASTER_KEY=<your_master_key>
   RAILS_ENV=production
   RAILS_LOG_TO_STDOUT=true
   RAILS_SERVE_STATIC_FILES=true
   DATABASE_URL=<from_postgres_service>
   REDIS_URL=<from_redis_service>
   SUPABASE_URL=<your_supabase_url>
   SUPABASE_ANON_KEY=<your_supabase_anon_key>
   ```

## Step 4: Get Your Rails Master Key

You need your Rails master key for production. Run this locally:

```bash
cat config/master.key
```

Copy the output and use it as the `RAILS_MASTER_KEY` environment variable in Render.

## Step 5: Configure Environment Variables

In your Render dashboard, go to your web service and add these environment variables:

### Required Variables:
- `RAILS_MASTER_KEY` - Your Rails master key
- `SUPABASE_URL` - Your Supabase project URL
- `SUPABASE_ANON_KEY` - Your Supabase anonymous key

### Automatically Set (if using render.yaml):
- `DATABASE_URL` - Automatically set from PostgreSQL service
- `REDIS_URL` - Automatically set from Redis service
- `RAILS_ENV=production`
- `RAILS_LOG_TO_STDOUT=true`
- `RAILS_SERVE_STATIC_FILES=true`

## Step 6: Monitor Deployment

1. **Check Build Logs**: Monitor the build process in Render dashboard
2. **Check Runtime Logs**: View application logs for any errors
3. **Health Check**: Your app should respond at the provided URL

## Step 7: Verify Deployment

Once deployed, your app will be available at:
`https://your-app-name.onrender.com`

Test these endpoints:
- Home page: `/`
- Wizard: `/wizard/step/1`
- Products: `/products`

## Troubleshooting

### Common Issues:

1. **Build Failures**:
   - Check that `bin/render-build.sh` is executable
   - Verify all gems are in the Gemfile
   - Check for any syntax errors

2. **Database Connection Issues**:
   - Verify `DATABASE_URL` is correctly set
   - Check that migrations run successfully

3. **Asset Compilation Errors**:
   - Ensure all JavaScript/CSS files are properly configured
   - Check for any missing dependencies

4. **Environment Variable Issues**:
   - Double-check all required environment variables are set
   - Verify Supabase credentials are correct

### Useful Commands:

```bash
# Check your Rails master key
cat config/master.key

# Test locally with production settings
RAILS_ENV=production bundle exec rails server

# Check asset compilation
RAILS_ENV=production bundle exec rails assets:precompile
```

## Free Tier Limitations

- **Web Services**: 750 hours/month (about 31 days)
- **PostgreSQL**: 90 days free trial, then $7/month
- **Redis**: 30 days free trial, then $6/month
- **Bandwidth**: 100GB/month
- **Build Time**: 500 minutes/month

## Next Steps

1. **Custom Domain**: Add a custom domain in Render settings
2. **SSL Certificate**: Automatically provided by Render
3. **Monitoring**: Set up alerts and monitoring
4. **Scaling**: Upgrade to paid plans when needed

## Support

- **Render Documentation**: [docs.render.com](https://docs.render.com)
- **Rails Deployment**: [guides.rubyonrails.org](https://guides.rubyonrails.org/deployment.html)
- **Render Community**: [community.render.com](https://community.render.com) 