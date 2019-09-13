# frozen_string_literal: true

class EventWorker
  include Sidekiq::Worker

  def perform(event_uuid)
    event = Event.find(event_uuid)
    telegram_notification = Milestone.first.try(:telegram_notification)

    return if event.nil? || telegram_notification.nil?

    telegram_notification.chat_ids.each do |chat_id|
      TelegramBot.new().bot.send_message(chat_id: chat_id.to_i, text: telegram_notification.message)
    end
  end
end
