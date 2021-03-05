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
    include ::FieldValues::RelevantFieldValidation
    include ::FieldValues::FromToValidation

    validate :validate_value, if: -> { value.present? }

    private
      def validate_value
        iso_date = decode(value)
        iso_value = format_date_iso_string(Time.iso8601(iso_date))

        errors.add(:value, I18n.t('shared.is_invalid_value')) unless iso_value == iso_date
      end

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
