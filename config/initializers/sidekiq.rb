# frozen_string_literal: true

sidekiq_config = { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379" } }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
