# frozen_string_literal: true

namespace :sample do
  desc 'generate sample event'
  task events: :environment do
    creator_id = 3
    user = User.find creator_id
    event_types = EventType.where(program_id: user.program_id).collect(&:id)

    provinces = Location.where(kind: 'province')

    provinces.each do |province|
      districts = province.children.order('random()').limit(7)

      districts.each do |district|
        communes = district.children.order('random()').limit(5)
        communes.each do |commune|
          villages = commune.children.where.not(geopoint: nil).limit(2)

          villages.each do |village|
            max_event = rand(5..30)
            (1..max_event).each do |i|
              date = Date.today - rand(0..7)
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
                event_date: date,
                report_date: date
              )

              event.save
            end
          end
        end
      end
    end
  end
end
