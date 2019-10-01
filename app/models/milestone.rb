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
#

class Milestone < ApplicationRecord
  # Association
  belongs_to :program
  has_many   :fields, dependent: :destroy

  # Validation
  validates :name, presence: true, uniqueness: true
  validate :validate_unique_field_name
  validate :validate_unique_field_type_location

  before_create :set_display_order
  before_create :set_default_fields, unless: :is_default?

  # Scope
  default_scope { order(display_order: :asc) }
  scope :root, -> { where(is_default: true) }

  # Nested attribute
  accepts_nested_attributes_for :fields, allow_destroy: true, reject_if: ->(attributes) { attributes['name'].blank? }

  # Class methods
  def self.create_root
    self.create({ name: 'New', is_default: true, fields_attributes: Field.roots })
  end

  private

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
