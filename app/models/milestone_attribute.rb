class MilestoneAttribute < ApplicationRecord
  FIELD_TYPES = %w[text integer date select_one select_multiple note image location mapping_field file].freeze
  MAPPING_FIELDS = [
    { name: 'risk_level', field_type: 'select_one' }
  ].freeze

  belongs_to :milestone
  has_many   :milestone_attribute_options, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :milestone_id, message: 'already exist' }
  validates :kind, presence: true, inclusion: { in: FIELD_TYPES }
  before_validation :set_mapping_field_type

  default_scope { order(display_order: :asc) }

  accepts_nested_attributes_for :milestone_attribute_options, allow_destroy: true, reject_if: ->(attributes) { attributes['name'].blank? }

  private

  def set_mapping_field_type
    return unless kind == 'mapping_field'

    field = MAPPING_FIELDS.find { |obj| obj[:name] == mapping_field }
    self.mapping_field_type = field.present? && field[:field_type]
  end
end
