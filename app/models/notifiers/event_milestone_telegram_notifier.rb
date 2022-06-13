# frozen_string_literal: true

class Notifiers::EventMilestoneTelegramNotifier
  attr_reader :event, :message

  def initialize(event_or_event_milestone)
    @event = event_or_event_milestone
    @message = event.milestone.message
  end

  def enabled?
    event.enable_telegram? &&
    message.try(:telegram_notification).present?
  end

  def recipients
    message.telegram_notification.chat_groups.actives.map(&:chat_id)
  end

  def display_message
    event.telegram_message
  end

  def display_title
  end

  def bot_token
    event.program.telegram_bot.try(:token)
  end
end
