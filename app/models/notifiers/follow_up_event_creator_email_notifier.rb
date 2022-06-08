class Notifiers::FollowUpEventCreatorEmailNotifier
  attr_reader :follow_up

  def initialize(follow_up)
    @follow_up = follow_up
  end

  def enabled?
    follow_up.channels.include?('email')
  end

  def recipients
    [follow_up.followee.email]
  end

  def display_message
    follow_up.message
  end

  def display_title
    "CamEMS follow up case: #{follow_up.event_id}"
  end

  def bot_token
    raise "It is for telegram channel only"
  end
end
