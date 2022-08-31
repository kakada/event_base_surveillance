# frozen_string_literal: true

require "sidekiq-scheduler"

class MbdsOutbreakReportWorker
  include Sidekiq::Worker

  def perform(*args)
    # ENV["MBDS_CREATOR_EMAIL"] must match to a user email in the EMS system
    # ignore if not found.
    creator = program.users.find_by email: ENV["MBDS_CREATOR_EMAIL"]

    return if creator.nil?

    MbdsOutbreakReportService.new(creator).process
  end
end
