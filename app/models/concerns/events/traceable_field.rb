# frozen_string_literal: true

module Events
  module TraceableField
    extend ActiveSupport::Concern

    included do
      before_create  :build_tracing
      before_update  :build_tracing

      private
        def build_tracing
          build_number_field
          build_text_field
        end

        def build_text_field
          fvs = tracking_fvs(text_tracking_codes)
          fvs.each do |fv|
            tracings.build(field_id: fv.field_id, field_value: fv.value, type: 'Tracings::TextTracing') if fv.value_changed?
          end
        end

        def build_number_field
          tracings.build(properties: build_number_props, type: 'Tracings::NumberTracing') if number_field_change?
        end

        def number_field_change?
          there_is_change = false
          fvs = tracking_fvs(number_tracking_codes)
          fvs.each do |fv|
            break if there_is_change

            there_is_change = fv.value_changed?
          end

          there_is_change
        end

        def build_number_props
          fvs = tracking_fvs(number_tracking_codes).pluck(:field_code, :value).to_h
          props = {}
          number_tracking_codes.each do |code|
            props[code] = fvs[code] || 0
          end

          props
        end

        def tracking_fvs(tracking_codes)
          field_values.select { |fv| tracking_codes.include? fv.field_code }
        end

        def number_tracking_codes
          @number_tracking_codes ||= milestone.fields.tracking.number.pluck(:code)
        end

        def text_tracking_codes
          @text_tracking_codes ||= milestone.fields.tracking.text.pluck(:code)
        end
    end
  end
end
