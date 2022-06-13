# frozen_string_literal: true

class Notifiers::EventScheduleEmailNotifier
  attr_reader :schedule, :event

  def initialize(schedule, event)
    @event = event
    @schedule = schedule
  end

  def enabled?
    schedule.enabled? &&
    schedule.channels.include?("email")
  end

  def recipients
    [event.creator.email]
  end

  def display_message
    schedule.display_message(event)
  end

  def display_title
    "CamEMS follow up case: #{event.id}"
  end

  def bot_token
    raise "It is for telegram channel only"
  end
end
