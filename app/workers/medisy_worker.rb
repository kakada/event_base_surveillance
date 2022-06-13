# frozen_string_literal: true

require "sidekiq-scheduler"

class MedisyWorker
  include Sidekiq::Worker

  def perform(*args)
    Medisy.find_each do |medisy|
      MedisyService.new(medisy).process_feed
    end
  end
end
