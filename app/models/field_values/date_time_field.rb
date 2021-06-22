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
  class DateTimeField < DateField
    def es_value
      Time.zone.parse(value) if value.present?
    end

    def html_tag
      value.present? ? I18n.l(DateTime.strptime(value, '%Y-%m-%d')) : value.to_s
    end
  end
end
