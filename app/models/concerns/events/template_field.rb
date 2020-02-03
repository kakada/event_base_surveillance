# frozen_string_literal: true

module Events
  module TemplateField
    extend ActiveSupport::Concern

    included do
      def self.template_fields(program)
        fields = [
          { code: 'event_type_name', label: 'Event Type' },
          { code: 'creator_email', label: 'Creator' },
          { code: 'program_name', label: 'Program' },
          { code: 'location_name', label: 'Location Name' }

        ]
        fields.each { |field| field[:code] = "#{default_template_code}#{field[:code]}" }
        fields += program.milestones.root.fields.map { |field| { code: "#{dynamic_template_code}#{field.id}_#{field.format_name}", label: field.name } }
        fields
      end

      def self.default_template_code
        'de_'
      end

      def self.dynamic_template_code
        'dy_'
      end
    end
  end
end
