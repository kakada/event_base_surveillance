# frozen_string_literal: true

class WebhookWorker
  include Sidekiq::Worker

  def perform(webhook_id, event_uuid)
    event = Event.find_by(uuid: event_uuid)
    webhook = Webhook.find_by(id: webhook_id)

    return if event.nil? || webhook.nil?

    webhook.notify(event: event.as_indexed_json)
  end
end
