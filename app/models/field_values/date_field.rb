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
  class DateField < ::FieldValue
    def valid_value?
      iso_date = decode(value)
      time = Time.iso8601(iso_date)
      iso_value = format_date_iso_string(time)
      iso_value == iso_date
    rescue StandardError
      false
    end

    def valid_condition?
      return true if field_validations.blank?

      iso_date = decode(value)
      iso_date_from = decode(field_validations[:from])
      iso_date_to = decode(field_validations[:to])

      iso_date >= iso_date_from && iso_date <= iso_date_to
    end

    private

    def decode(y_m_d_value)
      y_m_d_value.present? ? convert_to_iso8601_string(y_m_d_value) : nil
    rescue StandardError
      raise invalid_field_message
    end

    def invalid_field_message
      'Invalid date value'
    end

    def convert_to_iso8601_string(y_m_d_value)
      format_date_iso_string(parse_date(y_m_d_value))
    end

    def format_date_iso_string(time)
      time.strftime '%Y-%m-%dT00:00:00Z'
    end

    def parse_date(y_m_d_value)
      Time.strptime y_m_d_value, '%Y-%m-%d'
    end
  end
end
