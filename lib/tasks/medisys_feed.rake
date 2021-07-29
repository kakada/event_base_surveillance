# frozen_string_literal: true

namespace :medisys_feed do
  desc 'migrate program_id'
  task migrate_program_id: :environment do
    MedisysFeed.includes(:medisy).find_each do |feed|
      feed.update(program_id: feed.medisy.program_id)
    end
  end
end
