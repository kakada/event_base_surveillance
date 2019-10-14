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
        indexes :milestone, type: :object
      end

      def self.mappings_hash(program)
        properties = {}
        program.milestones.each do |milestone|
          milestone_name = milestone.name.downcase.split(' ').join('_')
          properties[milestone_name] = { type: 'object', properties: { created_at: { type: 'date' }, updated_at: { type: 'date' } } }

          unless milestone.is_default?
            properties[milestone_name][:properties][:conducted_at] = { type: 'date' }
            next
          end
          properties[milestone_name][:properties][:event_date] = { type: 'date' }
          properties[milestone_name][:properties][:report_date] = { type: 'date' }
        end

        structure = mappings.to_hash
        structure[:properties][:milestone][:properties] = properties
        structure
      end

      def as_indexed_json(_options = {})
        event = build_basic_attributes
        event = build_milestone(event)
        event
      end

      private

      def build_basic_attributes
        attributes.except(*except_attributes).merge(
          event_type_name: event_type_name,
          program_name: program_name,
          location_name: location_name,
          location: {
            lat: field_values.select { |fv| fv.field_code == 'latitude' }.first.value,
            lon: field_values.select { |fv| fv.field_code == 'longitude' }.first.value
          },
          milestone: {}
        )
      end

      def build_milestone(event)
        program.milestones.each_with_index do |ms, index|
          milestone_name = ms.name.downcase.split(' ').join('_')
          event[:milestone][milestone_name] = {}
          valueable = index.zero? ? self : event_milestones.select { |em| em.milestone_id == ms.id }.first

          next if valueable.nil?

          event[:milestone][milestone_name] = valueable.attributes.except(*except_attributes).merge(
            fields: valueable.field_values.includes(:field).map do |fv|
              fv.field.attributes.except(*except_date_attributes).merge(
                value: fv.value || fv.values || fv.image_url || fv.file_url,
                color: fv.color
              )
            end
          )
        end

        event
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
