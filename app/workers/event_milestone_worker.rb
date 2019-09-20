# frozen_string_literal: true

class EventMilestoneWorker
  include Sidekiq::Worker

  def perform(event_milestone_id)
    event_milestone = EventMilestone.find(event_milestone_id)
    return if event_milestone.nil?

    telegram = event_milestone.milestone.telegram
    return if telegram.nil?

    message = MessageInterpretor.new(telegram.message, event_milestone.event_uuid, event_milestone.id).message
    telegram.notify_groups(message)
  end
end
