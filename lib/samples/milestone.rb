# frozen_string_literal: true

module Samples
  class Milestone
    def self.load
      load_cdc
      load_gdaph
    end

    class << self
      private

      def load_cdc
        milestones = JSON.parse(File.read('lib/samples/db/cdc_milestone.json'))
        update_cdc_root_milestone
        create_milestone('CDC', milestones)
      end

      def load_gdaph
        milestones = JSON.parse(File.read('lib/samples/db/gdaph_milestone.json'))
        update_gdaph_root_milestone
        create_milestone('GDAPH', milestones)
      end

      def create_milestone(program_name, milestones)
        program = ::Program.find_by name: program_name

        milestones.each do |milestone|
          milestone[:creator_id] = program.creator_id
          program.milestones.create(milestone)
        end
      end

      def update_gdaph_root_milestone
        mileston = ::Program.find_by(name: 'GDAPH').milestones.root
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
      end

      def update_cdc_root_milestone
        milestone = ::Program.find_by(name: 'CDC').milestones.root
        milestone.update_attributes(
          fields_attributes: [
            {
              name: 'Number of hospitalized',
              code: 'number_of_hospitalized',
              field_type: 'Fields::IntegerField',
              tracking: true
            }
          ]
        )
      end
    end
  end
end
