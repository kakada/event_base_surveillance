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

            root_fields = Milestone.root.first.fields
            (1..max_event).each do |_i|
              date = Date.today - rand(0..30)
              Event.create(
                creator_id: creator_id,
                event_type_id: event_types.sample,
                field_values_attributes: [
                  {
                    field_id: root_fields.select{|f| f.code == 'province_id'}.first.id,
                    field_code: 'province_id',
                    value: province.id,
                  },
                  {
                    field_id: root_fields.select{|f| f.code == 'district_id'}.first.id,
                    field_code: 'district_id',
                    value: district.id,
                  },
                  {
                    field_id: root_fields.select{|f| f.code == 'commune_id'}.first.id,
                    field_code: 'commune_id',
                    value: commune.id,
                  },
                  {
                    field_id: root_fields.select{|f| f.code == 'village_id'}.first.id,
                    field_code: 'village_id',
                    value: village.id,
                  },
                  {
                    field_id: root_fields.select{|f| f.code == 'number_of_case'}.first.id,
                    field_code: 'number_of_case',
                    value: rand(1..5),
                  },
                  {
                    field_id: root_fields.select{|f| f.code == 'event_date'}.first.id,
                    field_code: 'event_date',
                    value: date,
                  },
                  {
                    field_id: root_fields.select{|f| f.code == 'report_date'}.first.id,
                    field_code: 'report_date',
                    value: Date.today,
                  }
                ]
              )
            end
          end
        end
      end
    end
  end
end
