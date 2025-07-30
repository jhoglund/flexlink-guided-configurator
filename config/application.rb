require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FlexlinkConfigurator
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Configure Redis for caching and sessions
    config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] }
    
    # Configure session store
    config.session_store :cookie_store, key: '_flexlink_configurator_session'

    # Configure Sidekiq for background jobs
    config.active_job.queue_adapter = :sidekiq

    # Configure time zone
    config.time_zone = 'UTC'

    # Configure locale
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en]

    # Configure generators
    config.generators do |g|
      g.test_framework :rspec, fixtures: true, view_specs: false, helper_specs: false, routing_specs: false, controller_specs: true, request_specs: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
  end
end 