# frozen_string_literal: true

module Samples
  class Milestone
    def self.load
      load_cdc
      load_gdaph
    end

    def self.load_cdc
      milestones = [
        {
          name: 'Verification',
          fields_attributes: [
            { name: 'Line Listing', field_type: 'Fields::FileField' },
            { name: 'Who?', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'PHD' }, { name: 'OD' }, { name: 'HC' }, {name: 'Other'}] },
            { name: 'Sample collected?', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Yes' }, { name: 'No' }] },
            { name: 'Preliminary outbreak report', field_type: 'Fields::NoteField' },
            { name: 'Verified By', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'C-CDC' }, { name: 'PHD RRT' }, { name: 'OD RRT' }] },
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
            { name: 'Line Listing Provided', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Yes' }, { name: 'No' }] },
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
            { name: 'Status', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Ongoing' }, { name: 'Over' }] },
            { name: 'Under controlled', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Contained' }, { name: 'Spread' }] },
            { name: 'Spread', field_type: 'Fields::TextField' },
            { name: 'Conclusion', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Methanol poisoning' }, { name: 'H5N1' }, { name: 'Khmer Noodle poisoning' }, { name: 'H3N2 cluster' }, { name: 'Parasite' }, { name: 'Bread with meal' }, { name: 'Water borne' }, { name: 'Food borne' }, { name: 'Zoonoic' }, { name: 'Polultry death' }, { name: 'Dog bites' }, { name: 'Snake bites' }, { name: 'Fever with rash' }, { name: 'Acute diarrhea' }, { name: 'Acute flaccid paralysis' }, { name: 'Environmental pollution' }, { name: 'uspected nosocomial' }, { name: 'Skin' }, { name: 'Meniningoencephalitis syndrome' }, { name: 'Acute jaundice' }, { name: 'Meningitis or encephalitis' }, { name: 'Acute hemorrhagic fever' }, { name: 'Acute respiratory infection' }] },
            { name: 'Close Date', field_type: 'Fields::DateField' }
          ]
        }
      ]

      program = ::Program.find_by name: 'CDC'
      milestones.each do |milestone|
        milestone[:creator_id] = program.creator_id
        program.milestones.create(milestone)
      end
    end

    def self.load_gdaph
      milestones = [
        {
          name: 'Verification',
          fields_attributes: [
            { name: 'Verify outbreak confirm', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Yes' }, { name: 'No' }] },
            { name: 'Replication of the case', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Yes' }, { name: 'No' }] },
            { name: 'Animal death', field_type: 'Fields::TextField' }
          ]
        },
        {
          name: 'Investigation',
          fields_attributes: [
            { name: 'Primary case?', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Yes' }, { name: 'No' }] },
            { name: 'Conducted person', field_type: 'Fields::TextField' },
            { name: 'Attendent list', field_type: 'Fields::FileField' },
            { name: 'Control measures implemented', field_type: 'Fields::TextField' },
            { name: 'Summary report', field_type: 'Fields::FileField' },
            { name: 'CAVET', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Yes' }, { name: 'No' }] },
            { name: 'Additional info', field_type: 'Fields::TextField', field_options_attributes: [{ name: 'Yes' }, { name: 'No' }] },
            { name: 'Sampling', field_type: 'Fields::FileField' },
            { name: 'Type of communication activity', field_type: 'Fields::TextField' }
          ]
        },
        {
          name: 'Risk Assessment',
          fields_attributes: [
            { name: 'Lab Name', field_type: 'Fields::TextField' },
            { name: 'Date submitted sample', field_type: 'Fields::DateField' },
            { name: 'Date for result', field_type: 'Fields::DateField' },
            { name: 'Lab result', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Food poisoning' }, { name: 'Influenza' }] },
            { name: 'Lab result attachment', field_type: 'Fields::FileField' },
            { name: 'Is it severe disease?', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Yes' }, { name: 'No' }] },

            { name: 'Retest Lab Name', field_type: 'Fields::TextField' },
            { name: 'Retest Date submitted to Lab', field_type: 'Fields::DateField' },
            { name: 'Retest Date for result', field_type: 'Fields::DateField' },
            { name: 'Retest Lab result', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Food poisoning' }, { name: 'Influenza' }] },
            { name: 'Retest Lab result attachment', field_type: 'Fields::FileField' }
          ]
        },
        {
          name: 'Intervention/Response',
          fields_attributes: [
            { name: 'Prakas attachment', field_type: 'Fields::FileField' },
            { name: 'Control method', field_type: 'Fields::SelectMultipleField', field_options_attributes: [{ name: 'Deaths' }, { name: 'Destroyed' }, { name: 'Culling' }, { name: 'Disinfection' }, { name: 'Bio security' }, { name: 'Movement control' }, { name: 'Surveliance' }] },
            { name: 'Awareness', field_type: 'Fields::TextField' },
            { name: 'Deaths', field_type: 'Fields::IntegerField' },
            { name: 'Destroyed', field_type: 'Fields::IntegerField' },
            { name: 'Culling', field_type: 'Fields::IntegerField' },
            { name: 'Slaughter', field_type: 'Fields::IntegerField' }
          ]
        },
        {
          name: 'Case Close',
          final: true,
          fields_attributes: [
            { name: 'Collect surrounding sample', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Yes' }, { name: 'No' }] },
            { name: 'Conducted person', field_type: 'Fields::TextField', field_options_attributes: [{ name: 'Deaths' }, { name: 'Destroyed' }, { name: 'Culling' }, { name: 'Disinfection' }, { name: 'Bio security' }, { name: 'Movement control' }, { name: 'Surveliance' }] },
            { name: 'Summary report', field_type: 'Fields::FileField' },
            { name: 'Sample testing and confirm from lab', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Yes' }, { name: 'No' }] },
            { name: 'Attachment of Prakas from MAFF to close case', field_type: 'Fields::FileField' }
          ]
        }
      ]

      program = ::Program.find_by name: 'GDAPH'
      mileston = program.milestones.root
      mileston.update_attributes(
        fields_attributes: [
          { name: 'Source of information', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Hotline' }, { name: 'Facebook' }, { name: 'Website' }, { name: 'Newspaper' }] },
          { name: 'Contact information of reporter', field_type: 'Fields::TextField' },
          { name: 'Index case', field_type: 'Fields::IntegerField' },
          { name: 'Type of species', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Cow' }, { name: 'Buffalo' }, { name: 'Pig' }, { name: 'Chicken' }, { name: 'Duck' }, { name: 'Goose' }, { name: 'Dog' }] },
          { name: 'Animal sick date', field_type: 'Fields::DateField' },
          { name: 'Animal sick and death reference', field_type: 'Fields::FileField' },
          { name: 'Population at risk', field_type: 'Fields::IntegerField' },
          { name: 'New or on-going', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Yes' }, { name: 'No' }] },
          { name: 'Clinical signs', field_type: 'Fields::NoteField' }
        ]
      )

      milestones.each do |milestone|
        milestone[:creator_id] = program.creator_id
        program.milestones.create(milestone)
      end
    end
  end
end
