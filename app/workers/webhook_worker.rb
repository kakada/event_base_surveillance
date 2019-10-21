# frozen_string_literal: true

require 'rest-client'

class WebhookWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(webhook_id, event_uuid)
    event = Event.find_by(uuid: event_uuid)
    webhook = Webhook.find_by(id: webhook_id)

    return if event.nil? || webhook.nil? || webhook.url.nil?

    RestClient.post(webhook.url, event.to_json)
  end
end
