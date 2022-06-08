class Notifiers::EventCreatorEmailNotifier
  attr_reader :event_milestone, :creator

  def initialize(event_milestone, message)
    @event_milestone = event_milestone
    @creator = event_milestone.event.creator
    @message = message
  end

  def enabled?
    creator.notification_channels.include?('email')
  end

  def recipients
    [creator.email]
  end

  def display_message
    EventMilestoneMessageInterpreter.new(event_milestone, @message).interpreted_message
  end

  def display_title
    "CamEMS Notification: Event #{event_milestone.event_uuid}"
  end

  def bot_token
    raise "It is for telegram channel only"
  end
end
