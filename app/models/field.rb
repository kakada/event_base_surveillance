# frozen_string_literal: true

# == Schema Information
#
# Table name: fields
#
#  id                 :bigint           not null, primary key
#  name               :string           not null
#  field_type         :string
#  required           :boolean
#  mapping_field      :string
#  mapping_field_type :string
#  display_order      :integer
#  milestone_id       :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Field < ApplicationRecord
  FIELD_TYPES = %w[text integer date select_one select_multiple note image location mapping_field file].freeze

  # Association
  belongs_to :milestone
  has_many   :field_options, dependent: :destroy

  # Validation
  validates :name, presence: true, uniqueness: { scope: :milestone_id, message: 'already exist' }
  validates :field_type, presence: true, inclusion: { in: FIELD_TYPES }
  before_validation :set_mapping_field_type

  before_create :set_display_order

  # Scope
  default_scope { order(is_default: :desc).order(display_order: :asc) }
  scope :dynamic, -> { where(is_default: false) }

  # Nested attributes
  accepts_nested_attributes_for :field_options, allow_destroy: true, reject_if: ->(attributes) { attributes['name'].blank? }

  # Class methods
  def self.primary_default_fields
    [
      { field_type: 'integer', name: 'Number of case', is_default: true, required: true },
      { field_type: 'integer', name: 'Number of death', is_default: true },
      { field_type: 'note', name: 'Description', is_default: true },
      { field_type: 'location', name: 'Location', is_default: true },
      { field_type: 'text', name: 'Province', is_default: true, required: true },
      { field_type: 'text', name: 'District', is_default: true },
      { field_type: 'text', name: 'Commune', is_default: true },
      { field_type: 'text', name: 'Village', is_default: true },
      { field_type: 'date', name: 'Event date', is_default: true, required: true },
      { field_type: 'date', name: 'Report date', is_default: true, required: true },
      { field_type: 'text', name: 'Status', is_default: true },
      { field_type: 'text', name: 'Risk level', is_default: true },
      { field_type: 'text', name: 'Risk color', is_default: true },
      { field_type: 'text', name: 'Source', is_default: true }
    ]
  end

  def self.secondary_default_fields
    [
      { field_type: 'date', name: 'Conducted at', is_default: true },
      { field_type: 'text', name: 'Source', is_default: true }
    ]
  end

  private

  def set_display_order
    self.display_order = self.class.maximum(:display_order).to_i + 1
  end

  def set_mapping_field_type
    return unless field_type == 'mapping_field'

    event_mapping_field = EventType::MAPPING_FIELDS.find { |obj| obj[:name] == mapping_field }
    self.mapping_field_type = event_mapping_field.present? && event_mapping_field[:field_type]
  end
end
