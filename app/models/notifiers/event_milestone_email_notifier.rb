# frozen_string_literal: true

class Notifiers::EventMilestoneEmailNotifier
  attr_reader :event, :message

  def initialize(event_or_event_milestone)
    @event = event_or_event_milestone
    @message = @event.milestone.message
  end

  def enabled?
    event.enable_email_notification? &&
    message.try(:email_notification).present?
  end

  def recipients
    message.email_notification.emails || []
  end

  def display_message
    event.telegram_message
  end

  def display_title
  end

  def bot_token
    raise "It is for telegram channel only"
  end
end
