# frozen_string_literal: true

class EventWorker
  include Sidekiq::Worker

  def perform(event_uuid)
    telegram_notification = Milestone.first.try(:telegram_notification)
    return if telegram_notification.nil?

    telegram_notification.notify_groups
  end
end
