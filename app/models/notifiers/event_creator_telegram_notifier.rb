# frozen_string_literal: true

class Notifiers::EventCreatorTelegramNotifier
  attr_reader :event_milestone, :creator

  def initialize(event_milestone, message)
    @event_milestone = event_milestone
    @creator = event_milestone.event.creator
    @message = message
  end

  def enabled?
    creator.telegram? &&
    creator.notification_channels.include?("telegram")
  end

  def recipients
    [creator.telegram_chat_id]
  end

  def display_message
    EventMilestoneMessageInterpreter.new(event_milestone, @message).interpreted_message
  end

  def display_title
  end

  def bot_token
    TelegramBot.system_bot_token
  end
end
