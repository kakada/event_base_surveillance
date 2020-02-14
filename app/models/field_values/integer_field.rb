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
    # Validation
    validate :valid_value?
    validate :valid_condition?

    def valid_value?
      return true if value.blank?

      value.integer?
    end

    def valid_condition?
      return true if value.blank? || field_validations.blank? || (field_validations[:from].blank? && field_validations[:to].blank?)

      num = value.to_i
      num_from = field_validations[:from].to_i
      num_to = field_validations[:to].to_i

      is_valid = num >= num_from if field_validations[:from].present?
      is_valid = num <= num_to if field_validations[:to].present?
      is_valid = num >= num_from && num <= num_to if field_validations[:from].present? && field_validations[:to].present?
      is_valid
    end
  end
end
