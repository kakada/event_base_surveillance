# frozen_string_literal: true

class EventMilestoneWorker
  include Sidekiq::Worker

  def perform(event_milestone_id)
    event_milestone = EventMilestone.find(event_milestone_id)
    return if event_milestone.nil?

    telegram_notification = event_milestone.milestone.telegram_notification
    return if telegram_notification.nil?

    telegram_notification.notify_groups
  end
end
