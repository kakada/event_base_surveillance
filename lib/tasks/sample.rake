# frozen_string_literal: true

namespace :sample do
  desc 'generate sample event'
  task events: :environment do
    creator_id = 2
    user = User.find creator_id
    event_types = EventType.where(program_id: user.program_id).collect(&:id)

    provinces = Pumi::Province.all

    provinces.each do |province|
      districts = Pumi::District.where(:province_id => province.id).sample(1)

      districts.each do |district|
        communes = Pumi::Commune.where(:district_id => district.id).sample(1)
        communes.each do |commune|
          villages = Pumi::Village.where(:commune_id => commune.id).sample(1)

          villages.each do |village|
            max_event = rand(5..30)
            lat = rand(12.0...12.5657)
            lng = rand(102.0...104.9910)

            (1..max_event).each do |i|
              date = Date.today - rand(0..7)
              event = Event.new(
                creator_id: creator_id,
                event_type_id: event_types.sample,
                district_id: district.id,
                commune_id: commune.id,
                village_id: village.id,
                latitude: lat,
                longitude: lng,
                geopoint: "#{lat},#{lng}",
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
