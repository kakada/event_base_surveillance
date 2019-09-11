# frozen_string_literal: true

namespace :location_data do
  desc 'import location data'
  task import: :environment do
    require 'csv'

    file_path = "#{Rails.root}/sample/locations.csv"
    unless File.file?(file_path)
      puts "Fail to import data. could not find #{file_path}"
      return
    end

    csv = CSV.read(file_path)
    csv.shift
    csv.each do |data|
      loc = Location.find_or_initialize_by(code: data[0])
      loc.name_en = data[1]
      loc.name_km = data[2]
      loc.kind = data[3]
      loc.parent_id = data[4]
      loc.geopoint = if data[5].present? && data[6].present? then "#{data[5]},#{data[6]}" else nil end

      loc.save
    end
  end


  desc 'export location data'
  task export: :environment do
    require 'csv'
    file_path = "#{Rails.root}/tmp/locations.csv"
    File.delete(file_path) if File.file?(file_path)
    File.new(file_path, "w")
    csv = CSV.open(file_path, 'w')
    csv << ['code', 'name_en', 'name_km', 'kind', 'parent_id', 'latitude', 'longitude']

    provinces = Location.where(kind: 'province').order(code: :asc)
    provinces.each do |province|
      location_to_csv province, csv
    end
  end

  def location_to_csv location, csv
    csv << [location.code, location.name_en, location.name_km, location.kind, location.parent_id, location.geopoint.try(:x), location.geopoint.try(:y)]
    children = location.children.order(code: :asc)
    children.each do |child|
      location_to_csv child, csv
    end
  end
end