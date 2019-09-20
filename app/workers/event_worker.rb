# frozen_string_literal: true

class EventWorker
  include Sidekiq::Worker

  def perform(event_uuid)
    telegram = Milestone.first.try(:telegram)
    return if telegram.nil?

    message = MessageInterpretor.new(telegram.message, event_uuid).message
    telegram.notify_groups(message)
  end
end
