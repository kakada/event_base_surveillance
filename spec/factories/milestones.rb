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
          { name: "# of Male", field_type: "integer" },
          { name: "# of Female", field_type: "integer" },
          { name: "# of Hospitalized", field_type: "integer" },
          { name: "# of Recovered", field_type: "integer" },
          { name: "# of Death", field_type: "integer" },
          { name: "Summary", field_type: "note" },
          { name: "Risk Assessment conducted", field_type: "select_one", field_options: [{ name: "Yes" }, { name: "No" }] },
          { name: "Risk Level", field_type: "mapping_field", mapping_field: 'risk_level', mapping_field_type: "select_one", field_options: [{ name: "Low", color: '#51b8b8' }, { name: "Moderate", color: '#51b865' }, { name: "High", color: '#d68bb2' }, { name: "Very High", color: '#e81c2a' }] },
          { name: "Risk assessment date", field_type: "date" },
        ]

        fields.each do |field|
          f = create(:field, name: field[:name], field_type: field[:field_type], mapping_field: field[:mapping_field], mapping_field_type: field[:mapping_field_type], milestone: milestone)

          if field[:field_type] == 'select_one' || field[:mapping_field_type] == 'select_one'
            field[:field_options].each do |option|
              f.field_options.create(name: option[:name], color: option[:color])
            end
          end
        end
      end
    end
  end
end
