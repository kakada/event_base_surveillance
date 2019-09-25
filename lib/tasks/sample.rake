# frozen_string_literal: true

namespace :sample do
  desc 'generate sample event'
  task events: :environment do
    creator_id = 2
    user = User.find creator_id
    event_types = EventType.where(program_id: user.program_id).collect(&:id)

    provinces = Location.where(kind: 'province')

    provinces.each do |province|
      districts = province.children.order('random()').limit(3)

      districts.each do |district|
        communes = district.children.order('random()').limit(5)

        communes.each do |commune|
          villages = commune.children.where.not(latitude: nil).limit(2)

          villages.each do |village|
            max_event = rand(5..30)

            (1..max_event).each do |_i|
              date = Date.today - rand(0..30)
              event = Event.new(
                creator_id: creator_id,
                event_type_id: event_types.sample,
                province_id: province.id,
                district_id: district.id,
                commune_id: commune.id,
                village_id: village.id,
                value: rand(1..5),
                event_date: date,
                report_date: Date.today
              )

              event.save
            end
          end
        end
      end
    end
  end
end
