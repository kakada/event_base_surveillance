class Notifiers::EventScheduleTelegramNotifier
  attr_reader :schedule, :event

  def initialize(schedule, event)
    @event = event
    @schedule = schedule
  end

  def enabled?
    schedule.enabled? &&
    schedule.channels.include?('telegram') &&
    event.creator.telegram?
  end

  def recipients
    [event.creator.telegram_chat_id]
  end

  def display_message
    ScheduleMessageInterpreter.new(schedule.id, event.id).interpreted_message
  end

  def display_title
  end

  def bot_token
    TelegramBot.system_bot_token
  end
end
