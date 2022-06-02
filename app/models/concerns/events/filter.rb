# frozen_string_literal: true

module Events
  module Filter
    extend ActiveSupport::Concern

    included do
      # Class Methods
      def self.filter(params = {})
        scope = all
        scope = scope.where(uuid: params[:uuid]) if params[:uuid].present?
        scope = scope.where("substring(location_code from 1 for 2) in (?)", params[:province_ids]) if params[:province_ids].present?
        scope = scope.where(event_type_id: params[:event_type_ids]) if params[:event_type_ids].present?
        scope = scope.where("event_date BETWEEN ? AND ?", params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?
        scope = filter_by_field_values(scope, params)
        scope = filter_by_type(scope, params)
        scope
      end

      private
        def self.filter_by_field_values(scope, params)
          return scope unless (params.keys & field_value_params).size.positive?

          scope = scope.joins(:field_values)
          scope = scope.where('field_values.field_code': 'risk_level', 'field_values.value': params[:risk_levels]) if params[:risk_levels].present?
          scope = scope.where('field_values.field_code': 'progress', 'field_values.value': params[:progresses]) if params[:progresses].present?
          scope = scope.where('field_values.field_code': 'source_of_information', 'field_values.value': params[:source_of_informations]) if params[:source_of_informations].present?
          scope
        end

        def self.field_value_params
          %w(risk_levels progresses source_of_informations)
        end

        def self.filter_by_type(scope, params)
          return scope if params[:program_id].blank? || params[:filter] == 'all_and_share'
          return scope.where('events.program_id = ?', params[:program_id]) if params[:filter].blank? || params[:filter] == 'all'
          return scope.where('events.program_id != ?', params[:program_id]) if params[:filter] == 'shared'
          scope
        end
    end
  end
end
