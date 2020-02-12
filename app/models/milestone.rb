# frozen_string_literal: true

# == Schema Information
#
# Table name: milestones
#
#  id            :bigint           not null, primary key
#  program_id    :integer
#  name          :string
#  display_order :integer
#  is_default    :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  final         :boolean          default(FALSE)
#  creator_id    :integer
#

class Milestone < ApplicationRecord
  # Association
  belongs_to :program
  belongs_to :creator, class_name: 'User'
  has_one    :message
  has_one    :telegram, class_name: 'Notifications::Telegram'
  has_many   :sections, dependent: :destroy
  has_many   :fields, dependent: :destroy

  # Validation
  validates :name, presence: true, uniqueness: { scope: [:program_id] }
  validate :only_one_final_milestone
  validate :validate_unique_section_name

  before_validation :set_default_section, unless: :is_default
  before_create :set_display_order

  # Scope
  default_scope { order(display_order: :asc) }
  scope :root, -> { where(is_default: true).first }
  scope :final, -> { where(final: true).first }

  # Deligation
  delegate :message, to: :telegram, prefix: :telegram, allow_nil: true
  delegate :format_name, to: :program, prefix: :program, allow_nil: true

  # Nested attribute
  accepts_nested_attributes_for :sections, allow_destroy: true

  # Class methods
  def self.create_root(creator_id)
    create(name: 'New', is_default: true, sections_attributes: Section.roots, creator_id: creator_id)
  end

  def self.update_order!(ids)
    ids.each_with_index do |id, index|
      where(id: id).update_all(display_order: index + 1)
    end
  end

  # Instand methods
  def template_fields
    return Event.template_fields(program) if self.is_default?

    fields.map do |field|
      {
        code: "#{EventMilestone.dynamic_template_code}#{field.id}_#{field.format_name}",
        label: field.name
      }
    end
  end

  def extra_fields
    is_default? ? [{ code: :event_type_id, type: :integer, label: 'Event Type ID' }] : [{ code: :event_uuid, type: :string, label: 'Event Uuid' }]
  end

  def format_name
    name.downcase.split(' ').join('_')
  end

  def build_default_section
    self.sections_attributes = Section.defaults
  end

  private
    def validate_unique_section_name
      validate_uniqueness_of_in_memory(sections, %i[name], 'duplicate')
    end

    def only_one_final_milestone
      return unless final?

      matches = program.milestones.where(final: true).where.not(id: id)

      errors.add(:final, 'cannot have another final milestone') if matches.exists?
    end

    def set_display_order
      self.display_order = program.milestones.maximum(:display_order).to_i + 1
    end

    def set_default_section
      self.sections_attributes = Section.defaults if sections.select{|section| section.default}.length == 0
    end
end
