# frozen_string_literal: true

module Events
  module LogCallback
    extend ActiveSupport::Concern

    included do
      before_create  :build_log
      before_update  :build_log

      private

      def build_log
        handle_number_field
        handle_text_field
      end

      def handle_number_field
        tracking_codes = milestone.fields.tracking.number.pluck(:code)
        return if tracking_codes.blank?

        fvs = field_values.select { |fv| tracking_codes.include? fv.field_code }
        return if fvs.blank?

        there_is_change = false
        fvs.each do |fv|
          break if there_is_change

          there_is_change = fv.value_changed?
        end

        fvs = fvs.pluck(:field_code, :value).to_h
        props = {}
        tracking_codes.each do |code|
          props[code] = fvs[code] || 0
        end

        logs.build(properties: props, type: 'Logs::NumberLog') if there_is_change
      end

      def handle_text_field
        tracking_codes = milestone.fields.tracking.text.pluck(:code)
        return if tracking_codes.blank?

        fvs = field_values.select { |fv| tracking_codes.include? fv.field_code }
        return if fvs.blank?

        fvs.each do |fv|
          logs.build(field_id: fv.field_id, field_value: fv.field_value, type: 'Logs::TextLog') if fv.value_changed?
        end
      end
    end
  end
end
