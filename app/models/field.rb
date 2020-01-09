# frozen_string_literal: true

# == Schema Information
#
# Table name: fields
#
#  id                 :bigint           not null, primary key
#  code               :string
#  name               :string
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
#  color_required     :boolean          default(FALSE)
#  validations        :text
#  tracking           :boolean          default(FALSE)
#

class Field < ApplicationRecord
  self.inheritance_column = :field_type

  FIELD_TYPES = %w[Fields::TextField Fields::NoteField Fields::IntegerField Fields::DateField Fields::DateTimeField Fields::SelectOneField Fields::SelectMultipleField Fields::ImageField Fields::FileField Fields::LocationField Fields::MappingField].freeze

  # Association
  belongs_to :milestone
  has_many   :field_options, dependent: :destroy
  has_many   :field_values, dependent: :destroy

  # Validation
  validates :code, presence: true, uniqueness: { scope: :milestone_id, message: 'already exist' }
  validates :name, presence: true, uniqueness: { scope: :milestone_id, message: 'already exist' }
  validates :field_type, presence: true, inclusion: { in: FIELD_TYPES }
  before_validation :set_field_code, if: -> { name.present? }
  before_validation :set_mapping_field_type

  before_create :set_display_order

  # Scope
  default_scope { order(is_default: :desc).order(display_order: :asc) }
  scope :dynamic, -> { where(is_default: false) }
  scope :entry_able, -> { where(entry_able: true) }
  scope :tracking, -> { where(tracking: true) }

  # Nested attributes
  accepts_nested_attributes_for :field_options, allow_destroy: true, reject_if: ->(attributes) { attributes['name'].blank? }

  serialize :validations, Hash

  def kind
    raise 'you have to implement in subclass'
  end

  def self.es_datatype
    raise 'you have to implement in subclass'
  end

  # Class methods
  def self.roots
    fields = [
      { code: 'number_of_case', field_type: 'Fields::IntegerField', name: 'Number of case', required: true, tracking: true },
      { code: 'number_of_death', field_type: 'Fields::IntegerField', name: 'Number of death', tracking: true },
      { code: 'description', field_type: 'Fields::NoteField', name: 'Description' },
      { code: 'province_id', field_type: 'Fields::LocationField', name: 'Province', required: true },
      { code: 'district_id', field_type: 'Fields::LocationField', name: 'District' },
      { code: 'commune_id', field_type: 'Fields::LocationField', name: 'Commune' },
      { code: 'village_id', field_type: 'Fields::LocationField', name: 'Village' },
      { code: 'event_date', field_type: 'Fields::DateTimeField', name: 'Onset date', required: true },
      { code: 'report_date', field_type: 'Fields::DateTimeField', name: 'Report date', required: true },
      { code: 'progress', field_type: 'Fields::TextField', name: 'Progress', entry_able: false },
      { code: 'risk_level', field_type: 'Fields::SelectOneField', name: 'Risk level', entry_able: false, color_required: true },
      { code: 'source', field_type: 'Fields::TextField', name: 'Source', entry_able: false }
    ]
    fields.each_with_index do |field, index|
      field[:display_order] = index + 1
      field[:is_default] = true
    end
  end

  def self.defaults
    [
      { code: 'conducted_at', field_type: 'Fields::DateTimeField', name: 'Conducted at', is_default: true, required: true },
      { code: 'source', field_type: 'Fields::TextField', name: 'Source', is_default: true, entry_able: false }
    ]
  end

  private

  def set_field_code
    self.code ||= name.downcase.split(' ').join('_')
  end

  def set_display_order
    self.display_order ||= milestone.present? && milestone.fields.maximum(:display_order).to_i + 1
  end

  def set_mapping_field_type
    return unless field_type == 'mapping_field'

    event_mapping_field = self.class.roots.find { |obj| obj[:code] == mapping_field }
    self.mapping_field_type = event_mapping_field.present? && event_mapping_field[:field_type]
    self.color_required = event_mapping_field.present? && event_mapping_field[:color_required]
  end
end
