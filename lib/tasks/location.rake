# frozen_string_literal: true

require 'samples/location'

namespace :location do
  desc 'import location data'
  task import: :environment do
    Samples::Location.load
  end

  desc 'export location data'
  task export: :environment do
    Samples::Location.export
  end
end
