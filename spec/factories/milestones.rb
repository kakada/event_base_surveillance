FactoryBot.define do
  factory :milestone do
    name    { FFaker::Name.name }
    program

    trait :root do
      is_default { true }

      after :create do |milestone|
        Field.roots.each do |field|
          create(:field, field.merge(milestone_id: milestone.id))
        end
      end
    end

    trait :risk_assessment do
      name      {'Risk Assessment'}

      after :create do |milestone|
        fields = [
          { name: "# of Male", field_type: "Fields::IntegerField" },
          { name: "# of Female", field_type: "Fields::IntegerField" },
          { name: "# of Hospitalized", field_type: "Fields::IntegerField" },
          { name: "# of Recovered", field_type: "Fields::IntegerField" },
          { name: "# of Death", field_type: "Fields::IntegerField" },
          { name: "Summary", field_type: "Fields::NoteField" },
          { name: "Risk Assessment conducted", field_type: "Fields::SelectOneField", field_options: [{ name: "Yes" }, { name: "No" }] },
          { name: "Risk Level", field_type: "Fields::MappingField", mapping_field: 'risk_level', mapping_field_type: "Fields::SelectOneField", field_options: [{ name: "Low", color: '#51b8b8' }, { name: "Moderate", color: '#51b865' }, { name: "High", color: '#d68bb2' }, { name: "Very High", color: '#e81c2a' }] },
          { name: "Risk assessment date", field_type: "Fields::DateField" },
        ]

        fields.each do |field|
          f = create(:field, name: field[:name], field_type: field[:field_type], mapping_field: field[:mapping_field], mapping_field_type: field[:mapping_field_type], milestone: milestone)

          if field[:field_type] == 'Fields::SelectOneField' || field[:mapping_field_type] == 'Fields::SelectOneField'
            field[:field_options].each do |option|
              f.field_options.create(name: option[:name], color: option[:color])
            end
          end
        end
      end
    end
  end
end
