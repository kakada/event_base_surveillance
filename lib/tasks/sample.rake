# frozen_string_literal: true

namespace :sample do
  desc 'generate sample event'
  task events: :environment do
    provinces = Location.where(kind: 'province')
    provinces.each do |province|
      districts = province.children.order('random()').limit(3)
      districts.each do |district|
        communes = district.children.order('random()').limit(5)
        communes.each do |commune|
          villages = commune.children.where.not(latitude: nil).limit(2)
          villages.each do |village|
            creat_event(province.id, district.id, commune.id, village.id)
          end
        end
      end
    end
  end

  def creat_event(province_id, district_id, commune_id, village_id)
    field_values = {
      province_id: province_id,
      district_id: district_id,
      commune_id: commune_id,
      village_id: village_id,
      number_of_case: rand(1..5),
      event_date: Date.today - rand(0..30),
      report_date: Date.today
    }

    root_fields = Milestone.root.fields
    field_values_attributes = field_values.map do |k, v|
      {
        field_id: root_fields.select { |f| f.code == k.to_s }.first.id,
        field_code: k,
        value: v
      }
    end

    user = User.find(2)
    event_type_ids = EventType.where(program_id: user.program_id).pluck(:id)
    max_event = rand(5..30)

    (1..max_event).each do
      Event.create(
        creator_id: user.id,
        event_type_id: event_type_ids.sample,
        field_values_attributes: field_values_attributes
      )
    end
  end
end
