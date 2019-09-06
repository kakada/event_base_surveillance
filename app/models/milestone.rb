class Milestone < ApplicationRecord
  belongs_to :program
  has_many   :fields

  validates :name, presence: true, uniqueness: true
  validate :validate_unique_field_name
  validate :validate_unique_field_type_location
  accepts_nested_attributes_for :fields, allow_destroy: true, reject_if: ->(attributes) { attributes['name'].blank? }

  private

  def validate_unique_field_name
    validate_uniqueness_of_in_memory(fields, %i[name], 'duplicate')
  end

  def validate_unique_field_type_location
    return if fields.select { |field| field.field_type == 'location' }.length < 2

    errors.add :field_type, 'location cannot be more than one'
  end
end
