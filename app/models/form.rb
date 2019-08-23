# frozen_string_literal: true

# == Schema Information
#
# Table name: forms
#
#  id           :bigint           not null, primary key
#  event_id     :integer
#  form_type_id :integer
#  submitter_id :integer
#  conducted_at :date
#  priority     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Form < ApplicationRecord
  belongs_to :event
  belongs_to :form_type
  belongs_to :submitter, class_name: 'User', optional: true
  has_many   :field_values, as: :valueable

  # History
  has_associated_audits

  # Validations
  validates :conducted_at, presence: true
  validate :validate_field_values, on: %i[create update]

  # Callback
  after_create :set_event_status

  accepts_nested_attributes_for :field_values, allow_destroy: true, reject_if: lambda { |attributes|
    attributes['id'].blank? && attributes['value'].blank? && attributes['image'].blank? && attributes['values'].blank? && attributes['file'].blank?
  }

  private

  def validate_field_values
    form_type&.fields&.each do |field|
      next unless field.required?

      obj = field_values.select { |value| value.field_id == field.id }.first
      errors.add field.name.downcase, 'cannot be blank' if !obj || obj[:value].blank?
    end
  end

  def set_event_status
    event.status = form_type.name
    event.save
  end
end
