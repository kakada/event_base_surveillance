FactoryBot.define do
  factory :field do
    name        { FFaker::Name.name }
    field_type  { 'Fields::TextField' }

    trait :risk_level_mapping_field do
      name                {'Risk Level'}
      field_type          {'Fields::MappingField'}
      mapping_field       {'risk_level'}
      mapping_field_type  {'Fields::SelectOneField'}

      after :create do |field|
        create(:field_option, name: 'Low', color: '#514c2a', field: field)
        create(:field_option, name: 'High', color: '#f0184a', field: field)
      end
    end
  end
end
