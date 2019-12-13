# frozen_string_literal: true

module Events
  module FieldValueValidation
    extend ActiveSupport::Concern

    included do
      validate :validate_required_field, on: %i[create update]
      validate :validate_field_value_datatype, on: %i[create update]

      private

      def validate_required_field
        program.present? && milestone&.fields&.each do |field|
          next unless field.required?

          obj = field_values.select { |fv| fv.field_id == field.id }.first
          errors.add field.name.downcase, 'cannot be blank' if !obj || obj[:value].blank?
        end
      end

      def validate_field_value_datatype
        field_values.each do |fv|
          temp_fv = "FieldValues::#{fv.field_type.split('::').last}".constantize.new(fv.attributes)

          if temp_fv.valid_value?
            errors.add fv.field_name.downcase, "the value should be from #{fv.field_validations[:from]} to #{fv.field_validations[:to]}" unless temp_fv.valid_condition?
          else
            errors.add fv.field_name.downcase, 'is invalid value'
          end
        end
      end
    end
  end
end
