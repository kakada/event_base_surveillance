# frozen_string_literal: true

FactoryBot.define do
  factory :field_value do
    valueable_id    { create(:event).id }
    valueable_type  { 'Event' }

    trait :date do
      field_id    { valueable.milestone.fields.find_by(code: :event_date).id }
      field_code  { field.code }
      value       { Date.today.to_s }
    end

    trait :integer do
      field_id    { valueable.milestone.fields.find_by(code: :number_of_case).id }
      field_code  { field.code }
      value       { rand(1...10) }
    end
  end
end
