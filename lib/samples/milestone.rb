# frozen_string_literal: true

module Samples
  class Milestone
    def self.load
      milestones = [
        # {
        #   name: 'New',
        #   fields_attributes: [
        #     { name: "Source of information", field_type: "select_one", field_options_attributes: [{name: "Hotline"}, {name: "RRT"}, {name: "Media monitoring"}, {name: "CamEWARN"}, {name: "CamLIS"}, {name: "NGO Partners"}, {name: "Other"}]},
        #     { name: "Additional information", field_type: "text"},
        #     { name: "WHO notified date", field_type: "date"},
        #     { name: "Status of report", field_type: "select_one", field_options_attributes: [{ name: "For verification by RRT" }, { name: "Verfified (confirmed)" }, { name: "False report" }, { name: "Refer to other agency" }]},
        #     { name: "Verification Date", field_type: "date"}
        #   ]
        # },
        {
          name: 'Risk Assessment',
          fields_attributes: [
            { name: '# of Male', field_type: 'Fields::IntegerField' },
            { name: '# of Female', field_type: 'Fields::IntegerField' },
            { name: '# of Hospitalized', field_type: 'Fields::IntegerField' },
            { name: '# of Recovered', field_type: 'Fields::IntegerField' },
            { name: '# of Death', field_type: 'Fields::IntegerField' },
            { name: 'Summary', field_type: 'Fields::NoteField' },
            { name: 'Risk Assessment conducted', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Yes' }, { name: 'No' }] },
            { name: 'Risk Level', field_type: 'Fields::MappingField', mapping_field: 'risk_level', mapping_field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Low', color: '#51b8b8' }, { name: 'Moderate', color: '#51b865' }, { name: 'High', color: '#d68bb2' }, { name: 'Very High', color: '#e81c2a' }] },
            { name: 'Risk assessment date', field_type: 'Fields::DateField' }
          ]
        },
        {
          name: 'Investigation',
          fields_attributes: [
            { name: 'Investigation conducted', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Yes' }, { name: 'No' }] },
            { name: 'Investigation date', field_type: 'Fields::DateField' },
            { name: 'Action Taken', field_type: 'Fields::NoteField' },
            { name: 'Samples collected', field_type: 'Fields::TextField' },
            { name: 'Sample collected date', field_type: 'Fields::DateField' },
            { name: 'Laboratory Results', field_type: 'Fields::TextField' },
            { name: 'Status of event', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Follow up' }, { name: 'Closed' }] }
          ]
        },
        {
          name: 'Conclusion',
          final: true,
          fields_attributes: [
            { name: 'Conclusion', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Methanol poisoning' }, { name: 'H5N1' }, { name: 'Khmer Noodle poisoning' }, { name: 'H3N2 cluster' }, { name: 'Parasite' }, { name: 'Bread with meal' }, { name: 'Water borne' }, { name: 'Food borne' }, { name: 'Zoonoic' }, { name: 'Polultry death' }, { name: 'Dog bites' }, { name: 'Snake bites' }, { name: 'Fever with rash' }, { name: 'Acute diarrhea' }, { name: 'Acute flaccid paralysis' }, { name: 'Environmental pollution' }, { name: 'uspected nosocomial' }, { name: 'Skin' }, { name: 'Meniningoencephalitis syndrome' }, { name: 'Acute jaundice' }, { name: 'Meningitis or encephalitis' }, { name: 'Acute hemorrhagic fever' }, { name: 'Acute respiratory infection' }] },
            { name: 'Close Date', field_type: 'Fields::DateField' }
          ]
        }
      ]

      program_cdc = ::Program.find_by name: 'CDC'

      milestones.each do |milestone|
        milestone[:creator_id] = program_cdc.creator_id
        program_cdc.milestones.create(milestone)
      end
    end
  end
end
