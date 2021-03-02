# frozen_string_literal: true

module FieldValues
  module FromToValidation
    extend ActiveSupport::Concern

    included do
      validate :validate_from_to, if: -> { value.present? && validations[:from].present? && validations[:to].present? }
      validate :validate_from, if: -> { value.present? && validations[:from].present? && !validations[:to].present? }
      validate :validate_to, if: -> { value.present? && !validations[:from].present? && validations[:to].present? }

      private
        def validate_from_to
          return if (decode(validations[:from]) .. decode(validations[:to])).cover? decode(value)

          errors.add :value, I18n.t('shared.must_be_from_to', from: validations[:from], to: validations[:to])
        end

        def validate_from
          return if decode(value) >= decode(validations[:from])

          errors.add :value, I18n.t('shared.must_be_from', from: validations[:from])
        end

        def validate_to
          return if decode(value) <= decode(validations[:to])

          errors.add :value, I18n.t('shared.must_not_over', to: validations[:to])
        end
    end
  end
end
