# frozen_string_literal: true

require "sidekiq-scheduler"

class MbdsOutbreakReportWorker
  include Sidekiq::Worker

  def perform(*args)
    creator = program.users.find_by email: ENV["MBDS_CREATOR_EMAIL"]

    return if creator.nil?

    MbdsOutbreakReportService.new(creator).process
  end
end
