# frozen_string_literal: true

# == Schema Information
#
# Table name: event_milestones
#
#  id           :bigint           not null, primary key
#  event_uuid   :string
#  milestone_id :integer
#  submitter_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class EventMilestone < ApplicationRecord
  belongs_to :event, foreign_key: :event_uuid
  belongs_to :milestone
  belongs_to :submitter, class_name: 'User', optional: true
  has_many   :field_values, as: :valueable, dependent: :delete_all

  # History
  has_associated_audits

  # Validations
  validate :validate_field_values, on: %i[create update]

  # Callback
  after_create :set_event_status
  after_save    { IndexerWorker.perform_async(:index, event_uuid) }
  after_destroy { IndexerWorker.perform_async(:delete, event_uuid) }

  # Nested attributes
  accepts_nested_attributes_for :field_values, allow_destroy: true, reject_if: lambda { |attributes|
    attributes['id'].blank? && attributes['value'].blank? && attributes['image'].blank? && attributes['values'].blank? && attributes['file'].blank?
  }

  def conducted_at
    field_values.find_by(field_code: 'conducted_at').value
  end

  private

  def validate_field_values
    milestone&.fields&.each do |field|
      next unless field.required?

      obj = field_values.select { |field_value| field_value.field_id == field.id }.first
      errors.add field.name.downcase, 'cannot be blank' if !obj || obj[:value].blank?
    end
  end

  def set_event_status
    fv = event.field_values.find_or_initialize_by(field_code: 'status')
    fv.value = milestone.name
    fv.field_id ||= event.program.milestones.root.fields.find_by(code: 'status').id
    fv.save
  end
end
