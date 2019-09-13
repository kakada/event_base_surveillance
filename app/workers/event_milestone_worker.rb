# frozen_string_literal: true

class EventMilestoneWorker
  include Sidekiq::Worker

  def perform(event_milestone_id)
    event_milestone = EventMilestone.find(event_milestone_id)
    return if event_milestone.nil?

    telegram_notification = event_milestone.milestone.telegram_notification
    return if telegram_notification.nil?

    telegram_notification.chat_ids.each do |chat_id|
      TelegramBot.new().bot.send_message(chat_id: chat_id.to_i, text: telegram_notification.message)
    end
  end
end
