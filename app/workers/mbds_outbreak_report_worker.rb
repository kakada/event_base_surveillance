# frozen_string_literal: true

require "sidekiq-scheduler"

class MbdsOutbreakReportWorker
  include Sidekiq::Worker

  def perform(*args)
    return unless (ENV["MBDS_ENABLED"] == "true" && creator.present?)

    MbdsOutbreakReportService.new(creator).process
  end

  private
    def creator
      @creator ||= User.find_by email: ENV["MBDS_CREATOR_EMAIL"]
    end
end
