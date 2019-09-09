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

  belongs_to :milestone
  has_many   :field_options, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :milestone_id, message: 'already exist' }
  validates :field_type, presence: true, inclusion: { in: FIELD_TYPES }
  before_validation :set_mapping_field_type

  default_scope { order(display_order: :asc) }

  accepts_nested_attributes_for :field_options, allow_destroy: true, reject_if: ->(attributes) { attributes['name'].blank? }

  private

  def set_mapping_field_type
    return unless field_type == 'mapping_field'

    event_mapping_field = EventType::MAPPING_FIELDS.find { |obj| obj[:name] == mapping_field }
    self.mapping_field_type = event_mapping_field.present? && event_mapping_field[:field_type]
  end
end
