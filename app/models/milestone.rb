# frozen_string_literal: true

# == Schema Information
#
# Table name: milestones
#
#  id            :bigint           not null, primary key
#  display_order :integer
#  final         :boolean          default(FALSE)
#  is_default    :boolean          default(FALSE)
#  name          :string
#  status        :integer
#  verified      :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  creator_id    :integer
#  program_id    :integer
#

class Milestone < ApplicationRecord
  # Association
  belongs_to :program
  belongs_to :creator, class_name: "User"
  has_one    :message
  has_one    :telegram_notification, class_name: "Notifications::TelegramNotification"
  has_one    :email_notification, through: :message
  has_many   :sections, dependent: :destroy
  has_many   :fields, dependent: :destroy

  enum status: {
    root: 1,
    verified: 2,
    final: 3,
  }

  STATUSES = statuses.keys.map { |r| [r.titlecase, r] }

  # Validation
  validates :name, presence: true, uniqueness: { scope: [:program_id] }
  validates :status, uniqueness: { scope: :program_id }, allow_nil: true
  validate :validate_unique_section_name

  before_validation :set_default_section, unless: :root?
  before_create :set_display_order

  # Scope
  default_scope { order(display_order: :asc) }
  scope :root, -> { where(status: :root).first }
  scope :finals, -> { where(status: :final) }
  scope :verified, -> { where(status: :verified).first }

  # Deligation
  delegate :message, to: :telegram, prefix: :telegram, allow_nil: true
  delegate :format_name, to: :program, prefix: :program, allow_nil: true

  # Nested attribute
  accepts_nested_attributes_for :sections, allow_destroy: true

  # Class methods
  def self.create_root(creator_id)
    create(name: "New", status: :root, sections_attributes: Section.roots, creator_id: creator_id)
  end

  # Instand methods
  def template_fields
    return Event.template_fields(program) if self.root?

    fields.map do |field|
      {
        code: "#{EventMilestone.dynamic_template_code}#{field.id}_#{field.format_name}",
        label: field.name
      }
    end
  end

  def extra_fields
    root? ? [{ code: :event_type_id, type: :integer, label: "Event Type ID" }] : [{ code: :event_uuid, type: :string, label: "Event Uuid" }]
  end

  def format_name
    name.downcase.split(" ").join("_")
  end

  def build_default_section
    self.sections_attributes = Section.defaults
  end

  def status_collection
    return [["Root", "root"]] if root?

    Milestone::STATUSES.drop(1)
  end

  def telegram_invalid_configure?
    program.telegram_bot.nil? || !program.telegram_bot.actived?
  end

  def telegram_not_ready?
    !program.telegram_bot.enabled? || telegram_notification.nil? || telegram_notification.chat_groups.blank?
  end

  def email_not_ready?
    !program.enable_email_notification? || email_notification.nil? || email_notification.emails.blank?
  end

  def relevant_fields(scope = :dates)
    fields = Field.unscoped.joins(:milestone).send(scope)
              .where("milestones.display_order": (1..display_order.to_i).to_a)
              .where("milestones.program_id": program_id)
              .order("milestones.display_order ASC")

    fields.includes(:milestone).map { |field| field.relevant_format }
  end

  private
    def validate_unique_section_name
      validate_uniqueness_of_in_memory(sections, %i[name], "duplicate")
    end

    def set_display_order
      self.display_order ||= program.milestones.maximum(:display_order).to_i + 1
    end

    def set_default_section
      self.sections_attributes = Section.defaults if sections.select { |section| section.default }.length == 0
    end
end
