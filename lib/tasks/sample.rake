# frozen_string_literal: true

namespace :db do
  desc 'prepare to run the test'
  task prepare_for_test: :environment do
    loc_ids = ['04020105', '01020105', '01040105', '04040101']
    event_types = EventType.all.limit(3).collect(&:id)
    creator_id = 2

    (1..100).each do |i|
      loc_id = loc_ids.sample
      village = Location.find(loc_id)
      commune = village.parent
      district = commune.parent
      province = district.parent

      event = Event.new(
        creator_id: creator_id,
        event_type_id: event_types.sample,
        latitude: village.geopoint.x,
        longitude: village.geopoint.y,
        province_id: province.id,
        district_id: district.id,
        commune_id: commune.id,
        village_id: village.id,
        location: [province.name_en, district.name_en, commune.name_en, village.name_en].join(','),
        value: rand(1..5),
        event_date: Date.today
      )

      event.save
    end
  end
end
