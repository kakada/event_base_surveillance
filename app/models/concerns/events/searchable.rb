# frozen_string_literal: true

module Events
  module Searchable
    extend ActiveSupport::Concern

    included do
      include Elasticsearch::Model

      mapping date_detection: false do
        indexes :location_name, type: :text
        indexes :location, type: :geo_point
        indexes :created_at, type: :date
        indexes :updated_at, type: :date
      end

      def self.mappings_hash(program)
        structure = mappings.to_hash

        program.milestones.each do |milestone|
          es_milestone = { type: 'object', properties: { created_at: { type: 'date' }, updated_at: { type: 'date' } } }

          milestone.fields.each do |field|
            es_milestone[:properties][field[:code]] = { type: field[:field_type].constantize.es_datatype }
          end

          structure[:properties][milestone.format_name] = es_milestone
        end

        structure
      end

      def as_indexed_json(_options = {})
        event = build_basic_attributes
        event = build_milestone(event)
        event
      end

      private
        def build_basic_attributes
          attrs = attributes.except(*except_attributes).merge(
            event_type_name: event_type_name,
            program_name: program_name,
            location_name: location_name,
            milestone: {}
          )

          if location_latlng.present?
            attrs[:location] = {
              lat: location_latlng.try(:first),
              lon: location_latlng.try(:last)
            }
          end

          attrs
        end

        def build_milestone(event)
          program.milestones.each_with_index do |ms, index|
            event[ms.format_name] = build_milestone_attr(ms, index)
          end

          event
        end

        def build_milestone_attr(milestone, index)
          valueable = index.zero? ? self : event_milestones.select { |em| em.milestone_id == milestone.id }.first
          return {} if valueable.nil?

          attrs = {}
          valueable.field_values.each do |fv|
            attrs[fv.field_code] = fv.es_value
          end

          valueable.attributes.except(*except_attributes).merge(attrs)
        end

        def except_attributes
          %w[program_id creator_id event_type_id event_uuid uuid id]
        end

        def except_date_attributes
          %w[created_at updated_at]
        end
    end
  end
end
