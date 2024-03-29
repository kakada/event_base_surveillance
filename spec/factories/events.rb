# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    transient do
      location { Location.first || create(:location) }
    end

    program
    event_type { create(:event_type, program: program) }
    creator    { create(:creator, program: program) }
    field_values_attributes {
                              province = location

                              field_values = {
                                province_id: province.code,
                                number_of_case: rand(1..5),
                                event_date: Date.today - rand(0..30),
                                report_date: Date.today,
                                progress: "New"
                              }

                              field_values.map do |k, v|
                                {
                                  field_id: program.milestones.root.fields.find_by(code: k.to_s).id,
                                  field_code: k,
                                  value: v
                                }
                              end
                            }
  end
end
