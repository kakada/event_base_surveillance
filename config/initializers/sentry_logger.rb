# frozen_string_literal: true

Raven.configure do |config|
  config.excluded_exceptions = []
  config.dsn = ENV['SENTRY_LOGGER_DSN']
end
