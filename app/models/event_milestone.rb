# frozen_string_literal: true

# == Schema Information
#
# Table name: event_milestones
#
#  id           :bigint           not null, primary key
#  event_uuid   :string
#  milestone_id :integer
#  submitter_id :integer
#  conducted_at :date
#  priority     :string
#  source       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class EventMilestone < ApplicationRecord
  belongs_to :event, foreign_key: :event_uuid
  belongs_to :milestone
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
    milestone&.fields&.each do |field|
      next unless field.required?

      obj = field_values.select { |field_value| field_value.field_id == field.id }.first
      errors.add field.name.downcase, 'cannot be blank' if !obj || obj[:value].blank?
    end
  end

  def set_event_status
    event.status = milestone.name
    event.save
  end
end
