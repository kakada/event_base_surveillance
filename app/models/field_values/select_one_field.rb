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
      label = option_html_tag(value)
      option = field.field_options.select { |o| o.value == value }.first
      option_value = option.try(:value) || value

      "<span data-relevant=#{field_code} value=#{option_value}>#{label}</span>"
    end

    private
      def option_html_tag(val)
        option = field.field_options.select { |opt| opt.value == val }.first

        return option.try(:name) || val unless option&.color.present?

        "<span class='badge-outline' style='border-color: #{option.color}; color: #{option.color}'>#{option.name}</span>"
      end
  end
end
