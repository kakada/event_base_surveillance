# frozen_string_literal: true

require "csv"

module Samples
  class Location
    def self.load
      file_path = "#{Rails.root}/sample/locations.csv"
      unless File.file?(file_path)
        puts "Fail to import data. could not find #{file_path}"
        return
      end

      csv = CSV.read(file_path)
      csv.shift
      csv.each do |data|
        loc = ::Location.find_or_initialize_by(code: data[0])
        loc.name_en = data[1]
        loc.name_km = data[2]
        loc.kind = data[3]
        loc.parent_id = data[4]
        if data[5].present? && data[6].present?
          loc.latitude = data[5]
          loc.longitude = data[6]
        end
        loc.save
      end
    end

    def self.export
      file_path = "#{Rails.root}/tmp/locations.csv"
      CSV.open(file_path, "w") do |csv|
        csv << %w[code name_en name_km kind parent_id latitude longitude]

        provinces = ::Location.where(kind: "province").order(code: :asc)
        provinces.each do |province|
          location_to_csv province, csv
        end
      end
    end

    class << self
      private
        def location_to_csv(location, csv)
          csv << [location.code, location.name_en, location.name_km, location.kind, location.parent_id, location.latitude, location.longitude]
          children = location.children.order(code: :asc)
          children.each do |child|
            location_to_csv child, csv
          end
        end
    end
  end
end
