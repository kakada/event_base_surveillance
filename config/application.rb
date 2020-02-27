# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ebs
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.active_job.queue_adapter = :sidekiq

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.fallbacks = true
    config.i18n.fallbacks = [:en]
    config.i18n.available_locales = [:en, :km]

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end

    config.time_zone = 'Bangkok'
    config.active_record.default_timezone = :local

    Raven.configure do |conf|
      conf.dsn = ENV['SENTRY_LOGGER_DSN']
    end
  end
end
