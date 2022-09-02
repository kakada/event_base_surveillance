# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  close                  :boolean          default(FALSE)
#  deleted_at             :datetime
#  event_date             :datetime
#  link_uuid              :string
#  location_code          :string
#  lockable_at            :datetime
#  referrer               :string
#  uuid                   :string(36)       not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  conclude_event_type_id :integer
#  creator_id             :integer
#  event_type_id          :integer
#  program_id             :integer
#
# Indexes
#
#  index_events_on_deleted_at  (deleted_at)
#

class Event < ApplicationRecord
  include Events::Searchable
  include Events::Callback
  include Events::TemplateField
  include Events::Filter
  include Events::Lockable
  include Events::Location
  include Events::Valueable
  include Events::FollowUp

  # Soft delete
  acts_as_paranoid

  # Association
  belongs_to :event_type
  belongs_to :conclude_event_type, class_name: "EventType", optional: true
  belongs_to :creator, class_name: "User", optional: true
  belongs_to :program
  belongs_to :location, foreign_key: :location_code, optional: true
  belongs_to :link_parent, class_name: "Event", foreign_key: :link_uuid, optional: true
  has_many   :link_children, class_name: "Event", foreign_key: :link_uuid
  has_many   :event_milestones, foreign_key: :event_uuid, primary_key: :uuid
  has_many   :event_shareds
  has_many   :program_shareds, through: :event_shareds, source: :program
  has_many   :follow_ups

  # History
  has_associated_audits

  # Deligation
  delegate :name, :color, to: :event_type, prefix: :event_type
  delegate :name, to: :program, prefix: true
  delegate :enable_telegram?, to: :program, prefix: false
  delegate :enable_email_notification?, to: :program, prefix: false
  delegate :email, :full_name, :phone_number, to: :creator, prefix: true, allow_nil: true
  delegate :latlng, to: :location, prefix: true, allow_nil: true
  delegate :guideline_url, to: :event_type, prefix: false, allow_nil: true
  delegate :name, :color, to: :conclude_event_type, prefix: true, allow_nil: true

  # Validation
  validates :event_type_id, presence: true

  # Callback
  before_validation :set_program_id
  before_create :secure_uuid

  after_create :set_event_progress
  after_create :set_event_share

  # Scope
  scope :order_desc, -> { order(event_date: :desc) }
  scope :uncloseds, -> { where(close: false, lockable_at: nil) }

  # Nested Attributes
  accepts_nested_attributes_for :field_values, allow_destroy: true, reject_if: lambda { |attributes|
    attributes["id"].blank? && attributes["value"].blank? && attributes["image"].blank? && attributes["values"].blank? && attributes["file"].blank?
  }
  accepts_nested_attributes_for :event_milestones, allow_destroy: true

  # Serialier
  serialize :referrer, Hash

  # Instant Methods
  def conducted_at
    @conducted_at ||= fv_conducted_at.try(:value)
  end

  def fv_conducted_at
    @fv_conducted_at ||= get_value_by_code("event_date")
  end

  def milestone
    @milestone ||= program.milestones.root
  end

  def milestone_id
    @milestone_id ||= milestone.id
  end

  def progress
    @progress ||= get_value_by_code("progress").try(:value)
  end

  def telegram_message
    @telegram_message ||= MessageInterpretor.new(milestone.message.message, uuid).message
  end

  def set_event_progress
    fv = field_values.find_or_initialize_by(field_code: "progress")
    fv.value = milestone.name
    fv.field_id ||= milestone.fields.find_by(code: "progress").id
    fv.save
  end

  def with_field_value
    data = {}

    milestone.fields.pluck(:code).each do |code|
      data[code] = field_values.select { |fv| fv.field_code == code }.first.try(:value)
    end

    data
  end

  def verified?
    @verified ||= event_milestones.collect(&:milestone_id).include? program.milestones.verified.try(:id)
  end

  def event_type_changed?
    conclude_event_type_id.present? && event_type_id != conclude_event_type_id
  end

  def shared_with?(program_id)
    program_shared_ids.include?(program_id)
  end

  def relevant_event_milestone(relevant_milestone_id = nil)
    nil
  end

  def self.search_by_uuid_or_event_type(keyword)
    joins(:event_type)
      .where("LOWER(event_types.name) LIKE ? OR LOWER(uuid) LIKE ?", "%#{keyword.downcase}%", "%#{keyword.downcase}%")
  end

  private
    def secure_uuid
      self.uuid ||= SecureRandom.hex(4)

      return unless self.class.exists?(uuid: uuid)

      self.uuid = SecureRandom.hex(4)
      secure_uuid
    end

    def set_program_id
      self.program_id = creator.present? && creator.program_id
    end

    def set_event_share
      self.program_shared_ids = event_type.program_shared_ids
    end
end
