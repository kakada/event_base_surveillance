# frozen_string_literal: true

# == Schema Information
#
# Table name: event_milestones
#
#  id           :bigint           not null, primary key
#  event_uuid   :string
#  milestone_id :integer
#  submitter_id :integer
#  program_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class EventMilestone < ApplicationRecord
  include Events::Callback
  include Events::FieldValueValidation

  belongs_to :event, foreign_key: :event_uuid
  belongs_to :milestone
  belongs_to :program
  belongs_to :submitter, class_name: 'User', optional: true
  has_many   :field_values, as: :valueable, dependent: :destroy

  # History
  has_associated_audits

  # Validations
  validates :milestone_id, uniqueness: { scope: [:event_uuid] }

  # Callback
  after_create :set_event_progress
  after_create :set_event_to_close, if: -> { milestone.final? }

  # Nested attributes
  accepts_nested_attributes_for :field_values, allow_destroy: true, reject_if: lambda { |attributes|
    attributes['id'].blank? && attributes['value'].blank? && attributes['image'].blank? && attributes['values'].blank? && attributes['file'].blank?
  }

  # Deligation
  delegate :enable_telegram?, to: :program, prefix: false
  delegate :event_type, to: :event, prefix: false

  # Class Methods
  def self.default_template_code
    'emde_'
  end

  def self.dynamic_template_code
    'emdy_'
  end

  # Instant Methods
  def conducted_at
    field_values.find_by(field_code: 'conducted_at').value
  end

  def telegram_message
    MessageInterpretor.new(milestone.telegram_message, event_uuid, id).message
  end

  private

  def set_event_progress
    fv = event.field_values.find_or_initialize_by(field_code: 'progress')
    fv.value = milestone.name
    fv.field_id ||= program.milestones.root.fields.find_by(code: 'progress').id
    fv.save
  end

  def set_event_to_close
    event.close = true
    event.save
  end
end
