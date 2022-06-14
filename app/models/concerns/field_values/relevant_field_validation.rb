# frozen_string_literal: true

module FieldValues
  module RelevantFieldValidation
    extend ActiveSupport::Concern

    included do
      validate :validate_relevant_field, if: -> { value.present? && validations[:operator].present? && validations[:relevant_field_code].present? }

      private
        def validate_relevant_field
          return unless relevant_field.present?

          current_value = decode(value)
          relevant_value = decode(relevant_field.value)
          is_valid = current_value.send(validations[:operator], relevant_value)

          errors.add :value, error_msg unless is_valid
        end

        # relevant_field_code => "milestone_id::field_id::field_code"
        def relevant_field
          return if tmp_valueable.nil?
          # only for date type
          return relevant_valueable.fv_conducted_at if relevant_milestone_id == Milestone::PREVIOUS_MILESTONE

          relevant_values.select { |fv| fv.field_id == relevant_field_id.to_i }[0]
        end

        def relevant_milestone_id
          @relevant_milestone_id ||= validations[:relevant_field_code].to_s.split("::")[0]
        end

        def relevant_field_id
          @relevant_field_id ||= validations[:relevant_field_code].to_s.split("::")[1]
        end

        def relevant_values
          @relevant_values ||= tmp_valueable.field_values.to_a + relevant_valueable.try(:field_values).to_a
        end

        def relevant_valueable
          @relevant_valueable ||= tmp_valueable.relevant_event_milestone(relevant_milestone_id)
        end

        def error_msg
          msg = relevant_field.field.name
          msg = "#{relevant_valueable.milestone.name}::#{msg}" if relevant_valueable.present?
          msg = "#{I18n.t('shared.must_be')} #{validations[:operator]} #{relevant_field.value} (#{msg})"
          msg
        end
    end
  end
end
