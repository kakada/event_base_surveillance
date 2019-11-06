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

          fields = Field.roots.select { |field| ['Fields::IntegerField', 'Fields::DateField'].include? field[:field_type] }
          fields.each do |field|
            properties[milestone_name][:properties][field[:code]] = { type: field[:field_type].constantize.new.kind }
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
          milestone_name = ms.name.downcase.split(' ').join('_')
          event[:milestone][milestone_name] = {}
          valueable = index.zero? ? self : event_milestones.select { |em| em.milestone_id == ms.id }.first

          next if valueable.nil?

          obj = {}
          valueable.field_values.includes(:field).map do |fv|
            obj[fv.field.code] = fv.value || fv.values || fv.image_url || fv.file_url

            obj[fv.field.code] = "Pumi::#{fv.field.code.split('_').first.titlecase}".constantize.find_by_id(fv.value).name_en if %w[province_id district_id commune_id village_id].include? fv.field.code
          end

          event[:milestone][milestone_name] = valueable.attributes.except(*except_attributes).merge(obj)
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
