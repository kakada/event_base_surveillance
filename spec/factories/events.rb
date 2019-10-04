FactoryBot.define do
  factory :event do
    program
    event_type
    creator

    before :create do |event|
      province = Location.first || create(:location)
      root_milestone = Milestone.root.presence || create(:milestone, :root)
      field_values = {
        province_id: province.code,
        number_of_case: rand(1..5),
        event_date: Date.today - rand(0..30),
        report_date: Date.today
      }

      field_values_attributes = field_values.map do |k, v|
        {
          field_id: root_milestone.fields.find_by(code: k.to_s).id,
          field_code: k,
          value: v
        }
      end

      event.field_values_attributes = field_values_attributes
    end
  end
end
