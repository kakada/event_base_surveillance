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
  has_one    :telegram, class_name: 'Notifications::Telegram'
  has_many   :fields, dependent: :destroy

  # Validation
  validates :name, presence: true, uniqueness: { scope: [:program_id] }
  validate :validate_unique_field_name
  validate :validate_unique_field_type_location
  validate :only_one_final_milestone
  validate :check_field_validation

  before_create :set_display_order
  before_create :set_default_fields, unless: :is_default?

  # Scope
  default_scope { order(display_order: :asc) }
  scope :root, -> { where(is_default: true).first }
  scope :final, -> { where(final: true).first }

  # Deligation
  delegate :message, to: :telegram, prefix: :telegram, allow_nil: true

  # Nested attribute
  accepts_nested_attributes_for :fields, allow_destroy: true, reject_if: ->(attributes) { attributes['name'].blank? }

  # Class methods
  def self.create_root(creator_id)
    create(name: 'New', is_default: true, fields_attributes: Field.roots, creator_id: creator_id)
  end

  def self.update_order!(ids)
    ids.each_with_index do |id, index|
      where(id: id).update_all(display_order: index + 1)
    end
  end

  # Instand methods
  def template_fields
    return [] if self == Milestone.first

    fields.map do |field|
      {
        code: "#{EventMilestone.dynamic_template_code}#{field.id}_#{field.name.downcase.split(' ').join('_')}",
        label: field.name
      }
    end
  end

  def extra_fields
    is_default? ? [{code: :event_type_id, type: :integer, label: 'Event Type ID'}] : [{code: :event_uuid, type: :string, label: 'Event Uuid'}]
  end

  private

  def check_field_validation
    fields.each do |field|
      errors.add field.name.downcase, 'both must be exist' if field.validations[:from].present? != field.validations[:to].present?
    end
  end

  def only_one_final_milestone
    return unless final?

    matches = program.milestones.where(final: true).where.not(id: id)

    errors.add(:final, 'cannot have another final milestone') if matches.exists?
  end

  def set_display_order
    self.display_order = program.milestones.maximum(:display_order).to_i + 1
  end

  def set_default_fields
    self.fields_attributes = Field.defaults
  end

  def validate_unique_field_name
    validate_uniqueness_of_in_memory(fields, %i[name], 'duplicate')
  end

  def validate_unique_field_type_location
    return if fields.select { |field| field.field_type == 'location' }.length < 2

    errors.add :field_type, 'location cannot be more than one'
  end
end
