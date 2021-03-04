# frozen_string_literal: true

# == Schema Information
#
# Table name: field_values
#
#  id             :bigint           not null, primary key
#  field_id       :integer
#  field_code     :string
#  value          :string
#  color          :string
#  values         :text             is an Array
#  properties     :text
#  image          :string
#  file           :string
#  valueable_id   :string
#  valueable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  type           :string
#

module FieldValues
  class IntegerField < ::FieldValue
    include ::FieldValues::RelevantFieldValidation
    include ::FieldValues::FromToValidation

    validate  :validate_value, if: -> { value.present? }

    def validate_value
      errors.add(:value, I18n.t('shared.is_invalid_value')) unless value.integer?
    end

    private
      def decode(value)
        value.to_i
      end
  end
end
