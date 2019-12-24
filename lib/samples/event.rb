# frozen_string_literal: true

module Samples
  class Event
    def self.load
      provinces = ::Location.where(kind: 'province')
      provinces.each do |province|
        districts = province.children.order('random()').limit(3)
        districts.each do |district|
          communes = district.children.order('random()').limit(5)
          communes.each do |commune|
            villages = commune.children.where.not(latitude: nil).limit(2)
            villages.each do |village|
              creat_event(province.code, district.code, commune.code, village.code)
            end
          end
        end
      end
    end

    private_class_method

    def self.creat_event(province_id, district_id, commune_id, village_id)
      ::Program.all.each do |program|
        field_values = {
          province_id: province_id,
          district_id: district_id,
          commune_id: commune_id,
          village_id: village_id,
          number_of_case: rand(1..20),
          number_of_death: rand(1..5),
          event_date: Date.today - rand(0..30),
          report_date: Date.today
        }

        field_values_attributes = field_values.map do |k, v|
          {
            field_id: program.milestones.root.fields.select { |f| f.code == k.to_s }.first.id,
            field_code: k,
            value: v
          }
        end

        event_type_ids = program.event_types.pluck(:id)

        # Change here for changing number of event
        max_event = rand(1..20)

        (1..max_event).each do
          event = ::Event.create(
            creator_id: program.users.first.try(:id),
            event_type_id: event_type_ids.sample,
            field_values_attributes: field_values_attributes
          )

          program.milestones.where(is_default: false).each do |milestone|
            values_attributes = [
              {
                field_id: milestone.fields.where(code: 'conducted_at').first.id,
                field_code: 'conducted_at',
                value: event.field_values.find_by(field_code: 'report_date').value.to_date + ((rand(1..5) * milestone.display_order).day)
              }
            ]

            event_milestone = event.event_milestones.create({
              program_id: program.id,
              milestone_id: milestone.id,
              field_values_attributes: values_attributes
            })
          end
        end
      end
    end
  end
end
