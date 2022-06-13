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
  class LocationField < ::FieldValue
    def es_value
      return value if %w(province_id district_id commune_id village_id).exclude? field_code

      location.name_en.split(" ").join("_") if location.present?
    end

    def display_value
      value
    end

    def html_tag
      return (value.presence || "-").to_s if %w(province_id district_id commune_id village_id).exclude? field_code

      (location.try(:name_km) || "-").to_s
    end

    private
      def location
        @location ||= "Pumi::#{field_code.split('_').first.titlecase}".constantize.find_by_id(value)
      end
  end
end
