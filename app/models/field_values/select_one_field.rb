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
  class SelectOneField < ::FieldValue
    def html_tag
      opt_value = field.field_options.find_by(value: value).try(:name) || value

      return "<span data-relevant=#{field_code} value=#{value}>#{opt_value}</span>" unless field_code == 'risk_level'

      "<span data-relevant=#{field_code} value=#{value} class='badge' style='background-color: #{color}; color: #fff'>#{opt_value}</span>"
    end
  end
end
