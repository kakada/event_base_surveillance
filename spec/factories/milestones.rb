# frozen_string_literal: true

FactoryBot.define do
  factory :milestone do
    name    { FFaker::Name.name }
    program
    creator_id { program.creator_id }

    before :create do |milestone|
      milestone.sections_attributes = Section.defaults if !milestone.is_default?
    end

    trait :risk_assessment do
      name       {'Risk Assessment'}
      is_default { false }
      sections_attributes {
        [{
          name:  'Additional Fields',
          fields_attributes: [
            { name: "# of Male", field_type: "Fields::IntegerField" },
            { name: "# of Female", field_type: "Fields::IntegerField" },
            { name: "# of Hospitalized", field_type: "Fields::IntegerField" },
            { name: "# of Recovered", field_type: "Fields::IntegerField" },
            { name: "# of Death", field_type: "Fields::IntegerField" },
            { name: "Summary", field_type: "Fields::NoteField" },
            { name: "Risk Assessment conducted", field_type: "Fields::SelectOneField", field_options_attributes: [{ name: "Yes" }, { name: "No" }] },
            { name: "Risk Level", field_type: "Fields::MappingField", mapping_field: 'risk_level', mapping_field_type: "Fields::SelectOneField", field_options_attributes: [{ name: "Low", color: '#51b8b8' }, { name: "Moderate", color: '#51b865' }, { name: "High", color: '#d68bb2' }, { name: "Very High", color: '#e81c2a' }] },
            { name: "Risk assessment date", field_type: "Fields::DateField" },
          ]
        }]
      }
    end
  end
end
