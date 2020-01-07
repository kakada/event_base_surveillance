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

          fv = field_values.select { |field_value| field_value.field_id == field.id }.first

          if %w[Fields::ImageField Fields::FileField].include? field.field_type
            db_fv = field_values.find_by(field_id: field.id)
            next if db_fv.present? || (fv && (fv.file_url.present? || fv.image_url.present?))
          end

          errors.add field.name.downcase, I18n.t('shared.cannot_be_blank') if !fv || (fv.value.blank? && fv.values.blank?)
        end
      end

      def validate_field_value_datatype
        field_values.each do |fv|
          field_value = "FieldValues::#{fv.field_type.split('::').last}".constantize.new(fv.attributes)

          if field_value.valid_value?
            errors.add fv.field_name.downcase, I18n.t('shared.value_should_be_from_to', from: fv.field_validations[:from], to: fv.field_validations[:to]) unless field_value.valid_condition?
          else
            errors.add fv.field_name.downcase, I18n.t('shared.is_invalid_value')
          end
        end
      end
    end
  end
end
