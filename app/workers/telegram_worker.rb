# frozen_string_literal: true

class TelegramWorker
  include Sidekiq::Worker

  def perform(event_uuid)
    event = Event.find_by(uuid: event_uuid)
    return if event.nil? || !event.program.enable_telegram?

    telegram = Milestone.root.try(:telegram)
    return if telegram.nil?

    # Notify to telegram
    message = MessageInterpretor.new(telegram.message, event_uuid).message
    telegram.notify_groups(message)
  end
end
