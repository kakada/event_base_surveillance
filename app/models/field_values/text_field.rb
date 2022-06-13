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
    def display_value
      value
    end

    def html_tag
      return (value || "-").to_s unless field_code == "progress"
      return "<span class='badge #{valueable.close? ? 'badge-success' : 'badge-warning'}'>#{value}</span>" if valueable.lockable_at.nil?

      dom = "<div class='position-relative' data-toggle='tooltip' title='#{I18n.t('event.will_lock_at', date: valueable.lockable_at.try(:to_date))}'>"
      dom += "<span class='badge badge-success'>#{value}</span>"
      dom += "<i class='fas fa-unlock-alt lockable_at'></i></div>"
      dom
    end
  end
end
