class EventMilestone < ApplicationRecord
  belongs_to :event
  belongs_to :milestone
  belongs_to :submitter, class_name: 'User', optional: true
  has_many   :milestone_field_values, as: :valueable

  # History
  has_associated_audits

  # Validations
  validates :conducted_at, presence: true
  validate :validate_milestone_field_values, on: %i[create update]

  # Callback
  after_create :set_event_status

  accepts_nested_attributes_for :milestone_field_values, allow_destroy: true, reject_if: lambda { |attributes|
    attributes['id'].blank? && attributes['value'].blank? && attributes['image'].blank? && attributes['values'].blank? && attributes['file'].blank?
  }

  private

  def validate_milestone_field_values
    milestone&.milestone_fields&.each do |field|
      next unless field.required?

      obj = milestone_field_values.select { |field_value| field_value.milestone_field_id == field.id }.first
      errors.add field.name.downcase, 'cannot be blank' if !obj || obj[:value].blank?
    end
  end

  def set_event_status
    event.status = milestone.name
    event.save
  end
end
