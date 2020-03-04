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
  class TextField < ::FieldValue
    def html_tag
      return (value || '-').to_s unless field_code == 'progress'

      "<span class='badge #{valueable.close? ? 'badge-success' : 'badge-warning'}'>#{value}</span>"
    end
  end
end
