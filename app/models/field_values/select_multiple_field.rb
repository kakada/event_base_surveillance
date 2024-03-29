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
  class SelectMultipleField < SelectOneField
    def es_value
      return if values.blank?

      values.map { |v| field.field_options.select { |opt| opt.value == v }.first.try(:name) || v }
    end

    def display_value
      es_value
    end

    def html_tag
      label = values.map { |v| option_html_tag(v) }.join(", ")
      opt_values = values.map { |v| field.field_options.select { |opt| opt.value == v }.first.try(:value) || v }.join(",")

      "<span data-relevant=#{field_code} value=#{opt_values}>#{label.presence || '-'}</span>"
    end
  end
end
