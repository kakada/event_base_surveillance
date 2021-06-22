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

          relevant_collection.select { |fv| fv.field_id == validations[:relevant_field_code].split('::')[1].to_i }[0]
        end

        def relevant_collection
          @relevant_collection ||= tmp_valueable.field_values.to_a + relevant_valueable.try(:field_values).to_a
        end

        def relevant_valueable
          return if tmp_valueable.milestone.root?
          return tmp_valueable.event if tmp_valueable.milestone.display_order == 2

          tmp_valueable.event.event_milestones.find_by(milestone_id: validations[:relevant_field_code].split('::')[0].to_i)
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
