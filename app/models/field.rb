# frozen_string_literal: true

# == Schema Information
#
# Table name: fields
#
#  id                 :bigint           not null, primary key
#  code               :string
#  name               :string           not null
#  field_type         :string
#  required           :boolean
#  mapping_field      :string
#  mapping_field_type :string
#  display_order      :integer
#  milestone_id       :integer
#  is_default         :boolean          default(FALSE)
#  entry_able         :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Field < ApplicationRecord
  FIELD_TYPES = %w[text integer date select_one select_multiple note image location mapping_field file].freeze

  MAPPING_FIELDS = [
    { code: 'risk_level', field_type: 'select_one' }
  ].freeze

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
  scope :entry_able, -> { where(entry_able: true) }

  # Nested attributes
  accepts_nested_attributes_for :field_options, allow_destroy: true, reject_if: ->(attributes) { attributes['name'].blank? }

  # Class methods
  def self.roots
    [
      { code: 'number_of_case', field_type: 'integer', name: 'Number of case', is_default: true, required: true },
      { code: 'number_of_death', field_type: 'integer', name: 'Number of death', is_default: true },
      { code: 'description', field_type: 'note', name: 'Description', is_default: true },
      { code: 'province_id', field_type: 'text', name: 'Province', is_default: true, required: true },
      { code: 'district_id', field_type: 'text', name: 'District', is_default: true },
      { code: 'commune_id', field_type: 'text', name: 'Commune', is_default: true },
      { code: 'village_id', field_type: 'text', name: 'Village', is_default: true },
      { code: 'event_date', field_type: 'date', name: 'Event date', is_default: true, required: true },
      { code: 'report_date', field_type: 'date', name: 'Report date', is_default: true, required: true },
      { code: 'status', field_type: 'text', name: 'Status', is_default: true, entry_able: false },
      { code: 'risk_level', field_type: 'text', name: 'Risk level', is_default: true, entry_able: false },
      { code: 'risk_color', field_type: 'text', name: 'Risk color', is_default: true, entry_able: false },
      { code: 'source', field_type: 'text', name: 'Source', is_default: true, entry_able: false }
    ]
  end

  def self.defaults
    [
      { code: 'conducted_at', field_type: 'date', name: 'Conducted at', is_default: true, required: true },
      { code: 'source', field_type: 'text', name: 'Source', is_default: true, entry_able: false }
    ]
  end

  private

  def set_display_order
    self.display_order = self.class.maximum(:display_order).to_i + 1
  end

  def set_mapping_field_type
    return unless field_type == 'mapping_field'

    event_mapping_field = MAPPING_FIELDS.find { |obj| obj[:code] == mapping_field }
    self.mapping_field_type = event_mapping_field.present? && event_mapping_field[:field_type]
  end
end
