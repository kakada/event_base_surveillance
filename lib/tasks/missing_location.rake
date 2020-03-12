# frozen_string_literal: true

namespace :missing_location do
  desc 'migrate missing locaiton'
  task migrate: :environment do
    locations = [
      { old: '12010801', new: '12130501' },
      { old: '120108', new: '121305' },
      { old: '120102', new: '121301' },
      { old: '15010906', new:  '15070106' }
    ]

    locations.each do |location|
      Event.where(location_code: location[:old]).update_all(location_code: location[:new])
    end

    migrate_locations
  end

  private
    def migrate_locations
      matched_location_files = %w(matched_communes matched_villages)
      new_location_files = %w(new_districts new_communes new_villages)

      matched_location_files.each do |filename|
        update_locations(filename)
      end

      new_location_files.each do |filename|
        create_new_locations(filename)
      end
    end

    def update_locations(filename)
      locations = get_data(filename)
      locations.each do |location|
        lo = ::Location.find_by(code: location['old'])
        lo.update_attributes(code: location['new']) if lo.present?
      end
    end

    def create_new_locations(filename)
      locations = get_data(filename)
      locations.each do |location|
        location_code = location['code']
        location_kind = ::Location.location_kind(location_code)
        pumi_loc = "Pumi::#{location_kind.titlecase}".constantize.find_by_id(location_code)

        next if pumi_loc.nil?

        loc = ::Location.find_or_initialize_by(code: location_code)
        loc.update_attributes(name_en: pumi_loc.name_en, name_km: pumi_loc.name_km, kind: location_kind, parent_id: location_code[0...-2])
      end
    end

    def get_data(filename)
      JSON.parse(File.read("lib/tasks/db/#{filename}.json"))
    end
end
