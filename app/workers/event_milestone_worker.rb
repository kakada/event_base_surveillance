# frozen_string_literal: true

class EventMilestoneWorker
  include Sidekiq::Worker

  def perform(event_milestone_id)
    event_milestone = EventMilestone.find_by(id: event_milestone_id)
    return if event_milestone.nil? || !event_milestone.program.enable_telegram?

    telegram = event_milestone.milestone.telegram
    return if telegram.nil?

    message = MessageInterpretor.new(telegram.message, event_milestone.event_uuid, event_milestone.id).message
    telegram.notify_groups(message)
  end
end
