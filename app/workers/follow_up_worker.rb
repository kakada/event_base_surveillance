# frozen_string_literal: true

class FollowUpWorker
  include Sidekiq::Worker

  def perform(id)
    follow_up = FollowUp.find(id)

    follow_up.channels.each do |channel|
      follow_up.send("notify_#{channel}")
    end
  end
end
