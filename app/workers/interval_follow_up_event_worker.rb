# frozen_string_literal: true

class IntervalFollowUpEventWorker
  include Sidekiq::Worker

  def perform(event_id)
    event = Event.find event_id
    interval_follow_up = event.program.interval_follow_up

    return unless interval_follow_up.enabled?

    interval_follow_up.channels.each do |channel|
      event.send("notify_#{channel}")
    end
  end
end
