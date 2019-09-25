# frozen_string_literal: true

module Events
  module Searchable
    extend ActiveSupport::Concern

    included do
      include Elasticsearch::Model
      include Elasticsearch::Model::Callbacks

      mapping do
        indexes :location_name, type: :text
        indexes :location, type: :geo_point
      end

      def as_indexed_json(_options = {})
        event = attributes.except(*initial_milestone_attributes).as_json.merge(
          event_type_name: event_type_name,
          program_name: program_name,
          location_name: location_name,
          location: { lat: latitude, lon: longitude },
          milestone: {}
        )

        program.milestones.each_with_index do |milestone, index|
          if index.zero?
            event[:milestone][:initial] = attributes.slice(*initial_milestone_attributes).as_json.merge(
              province_name: Pumi::Province.find_by_id(province_id).name_en,
              district_name: Pumi::District.find_by_id(district_id).try(:name_en),
              commune_name: Pumi::Commune.find_by_id(commune_id).try(:name_en),
              village_name: Pumi::Village.find_by_id(village_id).try(:name_en),
              field_values: field_values.map { |fv| fv.as_json.merge(field_name: fv.field_name) }
            )
            next
          end

          milestone_name = milestone.name.downcase.split(' ').join('_')
          event[:milestone][milestone_name] = {}

          event_milestone = event_milestones.select { |em| em.milestone_id == milestone.id }.first
          next if event_milestone.nil?

          event[:milestone][milestone_name] = event_milestone.as_json.merge(
            field_values: event_milestone.field_values.map { |fv| fv.as_json.merge(field_name: fv.field_name) }
          )
        end

        event
      end

      private

      def initial_milestone_attributes
        %w[value description event_date report_date province_id district_id commune_id village_id]
      end
    end
  end
end
