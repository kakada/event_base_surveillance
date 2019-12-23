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
          milestone_name = milestone.format_name
          properties[milestone_name] = { type: 'object', properties: { created_at: { type: 'date' }, updated_at: { type: 'date' } } }

          milestone.fields.each do |field|
            properties[milestone_name][:properties][field[:code]] = { type: field[:field_type].constantize.es_datatype }
          end
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
        obj = attributes.except(*except_attributes).merge(
          event_type_name: event_type_name,
          program_name: program_name,
          location_name: location_name,
          milestone: {}
        )

        if location_latlng.present?
          obj[:location] = {
            lat: location_latlng.try(:first),
            lon: location_latlng.try(:last)
          }
        end

        obj
      end

      def build_milestone(event)
        program.milestones.each_with_index do |ms, index|
          event[:milestone][ms.format_name] = build_milestone_attr(ms, index)
        end

        event
      end

      def build_milestone_attr(milestone, index)
        valueable = index.zero? ? self : event_milestones.select { |em| em.milestone_id == milestone.id }.first
        return { 'conducted_at': nil } if valueable.nil?

        obj = {}
        valueable.field_values.includes(:field).map do |fv|
          obj[fv.field.code] = fv.value || fv.values || fv.image_url || fv.file_url
          obj[fv.field.code] = Time.parse(fv.value) if %w[conducted_at event_date report_date].include? fv.field.code
          obj[fv.field.code] = "Pumi::#{fv.field.code.split('_').first.titlecase}".constantize.find_by_id(fv.value).try(:name_en) if %w[province_id district_id commune_id village_id].include? fv.field.code
        end

        valueable.attributes.except(*except_attributes).merge(obj)
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
