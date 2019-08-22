FactoryBot.define do
  factory :form_type do
    name        { FFaker::Name.name }
    event_type

    trait :with_field do |form_type|
      after :create do |form_type, evaluator|
        create(:field, fieldable_id: form_type.id, fieldable_type: 'FormType')
      end
    end
  end
end
