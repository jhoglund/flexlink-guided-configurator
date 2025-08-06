source 'https://rubygems.org'

ruby '3.3.1'

# Rails framework
gem 'rails', '~> 8.0.0'

# Environment variables
gem 'dotenv-rails', groups: %i[development test]

# Database
gem 'pg', '~> 1.1'
gem 'sqlite3', '~> 2.1'

# Web server
gem 'puma', '>= 5.0'

# Asset pipeline
gem 'sprockets-rails'

# Authentication
gem 'devise'

# Authorization
gem 'pundit'

# HTTP client for Supabase API
gem 'httparty'

# Supabase Ruby client
gem 'supabase'

# Background job processing
gem 'sidekiq'

# Redis for caching and sessions
gem 'redis'

# UI Framework - Tailwind CSS
gem 'tailwindcss-rails'

# Modern JavaScript
gem 'importmap-rails'
gem 'stimulus-rails'
gem 'turbo-rails'

# Forms and UI
gem 'simple_form', '~> 5.2.0'

# JSON handling
gem 'jbuilder', '~> 2.11'
gem 'oj', '~> 3.15'

# Background jobs
gem 'sidekiq-scheduler', '~> 5.0'

# Development and testing
group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
end

group :development do
  gem 'listen'
  gem 'rack-mini-profiler', '~> 3.0'
  gem 'spring'
  gem 'web-console'

  # Automatic testing with Guard
  gem 'guard'
  gem 'guard-minitest'
  gem 'guard-rails'
  gem 'guard-rspec'

  # Auto-reload browser on file changes
  gem 'guard-livereload'
  gem 'rack-livereload'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver', '>= 4.0.0.rc3'
  gem 'webdrivers', '~> 5.0'
end

group :test, :development do
  gem 'rubocop', '~> 1.50', require: false
  gem 'rubocop-rails', '~> 2.20', require: false
  gem 'rubocop-rspec', '~> 2.20', require: false
end
gem 'ruby-lsp', '~> 0.26.1', group: :development

gem 'solargraph', '~> 0.56.0', group: :development
