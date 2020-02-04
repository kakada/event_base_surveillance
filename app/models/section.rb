# == Schema Information
#
# Table name: sections
#
#  id            :bigint           not null, primary key
#  name          :string
#  milestone_id  :integer
#  display_order :integer
#  default       :boolean          default(FALSE)
#  display       :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Section < ApplicationRecord
  belongs_to :milestone
  has_many :fields

  accepts_nested_attributes_for :fields, allow_destroy: true, reject_if: ->(attributes) { attributes['name'].blank? }

  # Validation
  validates :name, presence: true, uniqueness: { scope: [:milestone_id] }
  # validate :validate_unique_field_name
  # validate :validate_unique_field_type_location
  validate :check_field_validation

  # Scope
  default_scope { order(default: :desc).order(display_order: :asc) }
  scope :dynamic, -> { where(default: false) }
  scope :default, -> { where(default: true) }

  before_create :set_default_fields, if: :default?

  # Class methods
  def self.roots
    [{ name: 'Primary Fields', default: true, fields_attributes: Field.roots }]
  end

  def self.defaults
    [{ name: 'Primary Fields', default: true, fields_attributes: Field.defaults }]
  end

  private

  def set_default_fields
    self.fields_attributes = Field.defaults.select{ |f| fields.collect(&:code).exclude? f[:code] }
  end

  def check_field_validation
    fields.each do |field|
      errors.add field.name.downcase, I18n.t('milestone.both_must_exist') if field.validations[:from].present? != field.validations[:to].present?
    end
  end

  def validate_unique_field_name
    validate_uniqueness_of_in_memory(fields, %i[name], 'duplicate')
  end

  def validate_unique_field_type_location
    return if fields.select { |field| field.field_type == 'location' }.length < 2

    errors.add :field_type, 'location cannot be more than one'
  end
end
