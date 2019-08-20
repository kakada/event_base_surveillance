# frozen_string_literal: true

namespace :location_data do
  desc 'import location data'
  task import: :environment do
    file_path = "#{Rails.root}/sample/locations.csv"
    unless File.file?(file_path)
      puts "Fail to import data. could not find #{file_path}"
      return
    end

    require 'csv'
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
      csv << [province.code, province.name_en, province.name_km, province.kind, province.parent_id, province.geopoint.try(:x), province.geopoint.try(:y)]

      districts = province.children.order(code: :asc)
      districts.each do |district|
        csv << [district.code, district.name_en, district.name_km, district.kind, district.parent_id, district.geopoint.try(:x), district.geopoint.try(:y)]
        communes = district.children.order(code: :asc)
        communes.each do |commune|
          csv << [commune.code, commune.name_en, commune.name_km, commune.kind, commune.parent_id, commune.geopoint.try(:x), commune.geopoint.try(:y)]

          villages = commune.children.order(code: :asc)
          villages.each do |village|
            csv << [village.code, village.name_en, village.name_km, village.kind, village.parent_id, village.geopoint.try(:x), village.geopoint.try(:y)]
          end
        end
      end
    end
  end
end