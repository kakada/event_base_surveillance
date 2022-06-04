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
  include Events::Valueable

  attr_accessor :conclude_event_type_id

  belongs_to :event, foreign_key: :event_uuid, touch: true
  belongs_to :milestone
  belongs_to :program
  belongs_to :submitter, class_name: 'User', optional: true

  # History
  has_associated_audits

  # Validations
  validates :milestone_id, uniqueness: { scope: [:event_uuid] }

  # Callback
  after_create :set_event_progress
  after_create :set_event_to_close, if: -> { milestone.final? }
  after_commit :set_event_conclude_event_type_id, if: -> { conclude_event_type_id.present? }, on: [:create, :update]
  after_create_commit :notify_that_milestone_created_async, unless: -> { event.creator_id == submitter_id  }
  after_update_commit :notify_that_milestone_updated_async, unless: -> { event.creator_id == submitter_id  }

  # Nested attributes
  accepts_nested_attributes_for :field_values, allow_destroy: true, reject_if: lambda { |attributes|
    attributes['id'].blank? && attributes['value'].blank? && attributes['image'].blank? && attributes['values'].blank? && attributes['file'].blank?
  }

  # Deligation
  delegate :enable_telegram?, to: :program, prefix: false
  delegate :enable_email_notification?, to: :program, prefix: false
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
    fv_conducted_at.value
  end

  def fv_conducted_at
    @fv_conducted_at ||= get_value_by_code('conducted_at')
  end

  def telegram_message
    MessageInterpretor.new(milestone.message.try(:message), event_uuid, id).message
  end

  private
    def set_event_progress
      return if event.close?

      fv = event.field_values.find_or_initialize_by(field_code: 'progress')
      fv.value = milestone.name
      fv.field_id ||= program.milestones.root.fields.find_by(code: 'progress').id
      fv.save
    end

    def set_event_to_close
      event.close = true
      event.save
    end

    def set_event_conclude_event_type_id
      event.update(conclude_event_type_id: conclude_event_type_id)
    end

    def notify_that_milestone_created_async
      message = "Event {{event_uuid}}, there is a new milestone('{{milestone_name}}') has been created by user {{submitter_email}}. Click <a href='{{event_url}}'>here</a> to view event detail in CamEMS"

      notify_creator_async(message)
    end

    def notify_that_milestone_updated_async
      message = "Event {{event_uuid}} in {{milestone_name}} milestone is being modified by user {{submitter_email}}. Click <a href='{{event_url}}'>here</a> to view event detail in CamEMS"

      notify_creator_async(message)
    end

    def notify_creator_async(message)
      event.creator.notification_channels.each do |channel|
        notify("Notifiers::EventCreator#{channel.titlecase}Notifier".constantize.new(self, message), channel)
      end
    end
end
