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
    def es_value
      return value if field.nil?

      field.field_options.find_by(value: value).try(:name) || value
    end

    def display_value
      es_value
    end

    def html_tag
      option = field.field_options.find_by(value: value)
      label = option.try(:name) || value
      option_value = option.try(:value) || value

      return "<span data-relevant=#{field_code} value=#{option_value}>#{label}</span>" unless field_code == 'risk_level'

      "<span data-relevant=#{field_code} value=#{option_value} class='badge' style='background-color: #{color}; color: #fff'>#{label}</span>"
    end
  end
end
