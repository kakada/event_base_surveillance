# frozen_string_literal: true

require "samples/ebs"

if Rails.env.development? || Rails.env.test?
  namespace :sample do
    desc "Clean db"
    task clean_db: :environment do
      require "database_cleaner"

      DatabaseCleaner[:active_record].strategy = :truncation
      DatabaseCleaner[:active_record].start
      DatabaseCleaner[:active_record].clean
    end

    desc "Loads sample data"
    task load: [:clean_db] do
      Samples::Ebs.load
    end
  end
end
