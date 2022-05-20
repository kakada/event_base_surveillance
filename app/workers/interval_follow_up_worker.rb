# frozen_string_literal: true

class IntervalFollowUpWorker
  include Sidekiq::Worker

  def perform(*args)
    Program.all.each do |program|
      next unless (program.interval_follow_up.present? &&
                   program.interval_follow_up.enabled? &&
                   program.interval_follow_up.duration_in_hour == Time.zone.now.hour
                  )

      notify_to_event_creators(program)
    end
  end

  private
    def notify_to_event_creators(program)
      events = program.events.reached_intervals(program.interval_follow_up.duration_in_day)
      events.each do |event|
        event.send_notification_async
      end
    end
end
