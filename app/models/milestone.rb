class Milestone < ApplicationRecord
  belongs_to :program
  has_many :milestone_attributes

  validates :name, presence: true, uniqueness: true
  validate :validate_unique_attr_name
  validate :validate_unique_attr_kind_location
  accepts_nested_attributes_for :milestone_attributes, allow_destroy: true, reject_if: ->(attributes) { attributes['name'].blank? }

  private

  def validate_unique_attr_name
    validate_uniqueness_of_in_memory(milestone_attributes, %i[name], 'duplicate')
  end

  def validate_unique_attr_kind_location
    return if milestone_attributes.select { |attribute| attribute.kind == 'location' }.length < 2

    errors.add :kind, 'location cannot be more than one'
  end
end
