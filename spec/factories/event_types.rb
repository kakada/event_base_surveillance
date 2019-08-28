FactoryBot.define do
  factory :event_type do
    name        { 'H5N1' }
    color       { FFaker::Color.hex_code }
    program
    user

    trait :with_field do
      after(:create) do |event_type, evaluator|
        create(:field, fieldable_id: event_type.id, fieldable_type: 'EventType')
      end
    end

    trait :with_assessment_form_type do
      after(:create) do |event_type, evaluator|
        create(:form_type, :with_field, name: 'Assessment', event_type: event_type)
      end
    end

  end
end
