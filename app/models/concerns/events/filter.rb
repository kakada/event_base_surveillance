# frozen_string_literal: true

module Events
  module Filter
    extend ActiveSupport::Concern

    included do
      # Class Methods
      def self.filter(params = {})
        scope = all
        scope = filter_by_keyword(scope, params)
        scope = scope.where("event_date BETWEEN ? AND ?", params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?
        scope = scope.where(event_type_id: params[:event_type_id]) if params[:event_type_id].present?
        scope = filter_by_type(scope, params)
        scope
      end

      private
        def self.filter_by_type(scope, params)
          return scope if params[:program_id].blank? || params[:filter] == 'all_and_share'
          return scope.where('events.program_id = ?', params[:program_id]) if params[:filter].blank? || params[:filter] == 'all'
          return scope.where('events.program_id != ?', params[:program_id]) if params[:filter] == 'shared'
          scope
        end

        def self.filter_by_keyword(scope, params)
          keywords = get_keywords(params[:keyword])

          return scope unless keywords.length > 1 && keywords.all?(&:present?)

          case keywords[0]
          when 'id'
            scope = scope.where(uuid: keywords[1])
          when 'suspected_event'
            scope = scope.joins(:event_type).where('LOWER(event_types.name) LIKE ?', "%#{keywords[1].downcase}%")
          else
            scope = scope.joins(:field_values).where('field_values.field_code = ? and field_values.value = ?', keywords[0], keywords[1])
          end

          scope
        end

        # "risk_level: 'high'" => ["risk_level", "high"]
        def self.get_keywords(keyword)
          return [] unless keyword.present?

          keyword.split(':').map{ |k| k.strip }
        end
    end
  end
end
