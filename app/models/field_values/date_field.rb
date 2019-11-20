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
      begin
        # value = '2019-11-19'
        iso_date_from = decode(value)
        time = Time.iso8601(iso_date_from)
        iso_value = format_date_iso_string(time)
        iso_value == iso_date_from
      rescue
        false
      end
    end

    private

    def decode(y_m_d_value)
      begin
        y_m_d_value.present? ? convert_to_iso8601_string(y_m_d_value) : nil
      rescue
        raise invalid_field_message()
      end
    end

    def invalid_field_message()
      "Invalid date value"
    end

    def convert_to_iso8601_string(y_m_d_value)
      format_date_iso_string(parse_date(y_m_d_value))
    end

    def format_date_iso_string(time)
      time.strftime "%Y-%m-%dT00:00:00Z"
    end

    def parse_date(y_m_d_value)
      Time.strptime y_m_d_value, '%Y-%m-%d'
    end
  end
end
