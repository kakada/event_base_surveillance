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
  class MappingField < ::FieldValue
    def display_value
      value
    end

    def html_tag
      return value.to_s if field.parent.nil? || ["Fields::SelectOneField", "Fields::SelectMultipleField"].exclude?(field.parent.field_type)

      "FieldValues::#{field.parent.field_type.split('::').last}".constantize.new(value: value, values: values, field: field.parent).html_tag
    rescue
      value.to_s
    end
  end
end
