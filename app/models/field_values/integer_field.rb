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
    def valid_value?
      value.integer?
    end

    def valid_condition?
      return true if field_validations.blank?

      num = value.to_i
      num_from = field_validations[:from].to_i
      num_to = field_validations[:to].to_i

      num >= num_from && num <= num_to
    end
  end
end
