# frozen_string_literal: true

class ScheduleWorker
  include Sidekiq::Worker

  def perform(*args)
    Schedule.all.each do |schedule|
      next unless schedule.enabled? && schedule.reached_hour?

      schedule.send_notification_async
    end
  end
end
