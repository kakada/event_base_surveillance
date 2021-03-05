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

    trait :file do
      field       { build(:field, :file, section: valueable.milestone.sections.default[0], milestone: valueable.milestone) }
      field_code  { field.code }
      file        { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'sample.jpg')) }
    end

    trait :image do
      field       { build(:field, :image, section: valueable.milestone.sections.default[0], milestone: valueable.milestone) }
      field_code  { field.code }
      image       { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'sample.jpg')) }
    end

    trait :select_multiple do
      field       { build(:field, :select_multiple, section: valueable.milestone.sections.default[0], milestone: valueable.milestone) }
      field_code  { field.code }
      values      { ['option1', 'option2'] }
    end
  end

  factory :field_value_select_one, class: 'FieldValues::SelectOneField' do
    valueable_id    { create(:event).id }
    valueable_type  { 'Event' }

    trait :with_hotline_option do
      field_id    { valueable.milestone.fields.find_by(code: :source_of_information).id }
      field_code  { field.code }
      value       { 'hotline' }
    end
  end
end
