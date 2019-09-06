class Milestone < ApplicationRecord
  belongs_to :program
  has_many :milestone_fields

  validates :name, presence: true, uniqueness: true
  validate :validate_unique_field_name
  validate :validate_unique_field_kind_location
  accepts_nested_attributes_for :milestone_fields, allow_destroy: true, reject_if: ->(attributes) { attributes['name'].blank? }

  private

  def validate_unique_field_name
    validate_uniqueness_of_in_memory(milestone_fields, %i[name], 'duplicate')
  end

  def validate_unique_field_kind_location
    return if milestone_fields.select { |attribute| attribute.kind == 'location' }.length < 2

    errors.add :kind, 'location cannot be more than one'
  end
end
