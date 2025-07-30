source "https://rubygems.org"

ruby "3.2.9"

# Rails framework
gem "rails", "~> 8.0.0"

# Database
gem "pg", "~> 1.1"
gem "sqlite3", "~> 1.4"

# Web server
gem "puma", ">= 5.0"

# Asset pipeline
gem "sprockets-rails"

# Authentication
gem "devise"

# Authorization
gem "pundit"

# HTTP client for Supabase API
gem "httparty"

# Supabase Ruby client
gem "supabase"

# Background job processing
gem "sidekiq"

# Redis for caching and sessions
gem "redis"

# UI Framework - using a simpler approach
gem "bootstrap", "~> 5.3.0"
gem "dartsass-sprockets"

# Modern JavaScript
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# Forms and UI
gem "simple_form", "~> 5.2.0"

# JSON handling
gem "jbuilder", "~> 2.11"
gem "oj", "~> 3.15"

# Background jobs
gem "sidekiq-scheduler", "~> 5.0"

# Development and testing
group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console"
  gem "listen"
  gem "rack-mini-profiler", "~> 3.0"
  gem "spring"
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver", ">= 4.0.0.rc3"
  gem "webdrivers", "~> 5.0"
end

group :test, :development do
  gem "rubocop", "~> 1.50", require: false
  gem "rubocop-rails", "~> 2.20", require: false
  gem "rubocop-rspec", "~> 2.20", require: false
end 