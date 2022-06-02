# frozen_string_literal: true

class EventFollowUpWorker
  include Sidekiq::Worker

  def perform(event_id, schedule_id)
    event = Event.find event_id
    schedule = Schedule.find schedule_id

    return unless schedule.enabled?

    schedule.channels.each do |channel|
      message = ScheduleMessageInterpreter.new(schedule_id, event_id).interpreted_message

      event.send("notify_#{channel}", message)
    end
  end
end
