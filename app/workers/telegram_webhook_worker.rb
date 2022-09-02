# frozen_string_literal: true

class TelegramWebhookWorker
  include Sidekiq::Worker

  def perform(klass_name, message = {})
    "::TelegramWebhooks::#{klass_name}".constantize.new(message).process
  rescue
    Rails.logger.warn "Unknown model ::TelegramWebhooks::#{klass_name}"
  end
end
