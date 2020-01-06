# frozen_string_literal: true

module Samples
  class Milestone
    def self.load
      milestones = [
        {
          name: 'Verification',
          fields_attributes: [
            { name: 'Status', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Positive' }, { name: 'Negative' }] },
            { name: 'Summary', field_type: 'Fields::NoteField' },
            { name: 'Report Attachment', field_type: 'Fields::FileField' },
            { name: 'Conducted By (Lead)', field_type: 'Fields::TextField' },
            { name: 'Attendee List', field_type: 'Fields::TextField' }
          ]
        },
        {
          name: 'Risk Assessment',
          fields_attributes: [
            { name: 'Risk Level', field_type: 'Fields::MappingField', color_required: true, mapping_field: 'risk_level', mapping_field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Low', color: '#51b8b8' }, { name: 'Moderate', color: '#51b865' }, { name: 'High', color: '#d68bb2' }, { name: 'Very High', color: '#e81c2a' }] },
            { name: 'Risk Assessment conducted', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Yes' }, { name: 'No' }] },
            { name: 'Summary', field_type: 'Fields::NoteField' },
            { name: 'Summary Report Attachment', field_type: 'Fields::FileField' },
            { name: 'Conducted By (Lead)', field_type: 'Fields::TextField' },
            { name: 'Attendee List', field_type: 'Fields::TextField' }
          ]
        },
        {
          name: 'Investigation',
          fields_attributes: [
            { name: 'Action Taken', field_type: 'Fields::NoteField' },
            { name: 'Samples collected', field_type: 'Fields::TextField' },
            { name: 'Sample collected date', field_type: 'Fields::DateField' },
            { name: 'Laboratory Results', field_type: 'Fields::TextField' },
            { name: 'Status of event', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Follow up' }, { name: 'Closed' }] }
          ]
        },
        {
          name: 'Public Communication',
          fields_attributes: [
            { name: 'Risk Assessment conducted', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Press Release' }, { name: 'Web site' }, { name: 'Social Media' }, { name: 'News' }, { name: 'TV/Radio' }, { name: 'Other' }] },
            { name: 'Conducted By (Lead)', field_type: 'Fields::TextField' }
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

      ::Program.all.each do |program|
        milestones.each do |milestone|
          milestone[:creator_id] = program.creator_id
          program.milestones.create(milestone)
        end
      end
    end
  end
end
