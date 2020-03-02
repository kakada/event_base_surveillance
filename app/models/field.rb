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
#  description        :text
#  tracking           :boolean          default(FALSE)
#  section_id         :integer
#  relevant           :string
#

class Field < ApplicationRecord
  self.inheritance_column = :field_type

  attr_accessor :skip_validation

  FIELD_TYPES = %w[Fields::TextField Fields::NoteField Fields::IntegerField Fields::DateField Fields::DateTimeField Fields::SelectOneField Fields::SelectMultipleField Fields::ImageField Fields::FileField Fields::LocationField Fields::MappingField].freeze

  # Association
  belongs_to :section
  belongs_to :milestone
  belongs_to :parent, foreign_key: :mapping_field_id, class_name: 'Field', optional: true
  has_many   :field_options, dependent: :destroy
  has_many   :field_values

  # Validation
  validates :code, presence: true, uniqueness: { scope: :section_id, message: 'already exist' }
  validates :name, presence: true, uniqueness: { scope: :section_id, message: 'already exist' }
  validates :field_type, presence: true, inclusion: { in: FIELD_TYPES }
  validates :mapping_field_id, presence: true, if: -> { field_type == 'Fields::MappingField' && !skip_validation }

  before_validation :set_field_code, if: -> { name.present? }
  before_validation :set_mapping_field_type
  before_validation :set_milestone
  before_create :set_display_order

  # Scope
  default_scope { order(is_default: :desc).order(display_order: :asc) }
  scope :dynamic, -> { where(is_default: false) }
  scope :default, -> { where(is_default: true) }
  scope :entry_able, -> { where(entry_able: true) }
  scope :tracking, -> { where(tracking: true) }
  scope :number, -> { where(field_type: 'Fields::IntegerField') }
  scope :text, -> { where.not(field_type: 'Fields::IntegerField') }
  scope :except_locations, -> { where.not(code: %w(province_id district_id commune_id village_id)) }

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
      { code: 'risk_level', field_type: 'Fields::SelectOneField', name: 'Risk level', entry_able: false, color_required: true, tracking: true, field_options_attributes: [{ name: 'Low', color: '#51b8b8' }, { name: 'Moderate', color: '#51b865' }, { name: 'High', color: '#d68bb2' }, { name: 'Very high', color: '#e81c2a' }] },
      { code: 'source_of_information', field_type: 'Fields::SelectOneField', name: 'Source of information', field_options_attributes: [{ name: 'Hotline' }, { name: 'Facebook' }, { name: 'Website' }, { name: 'Newspaper' }] }
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

  def format_name
    name.downcase.split(' ').join('_')
  end

  private
    def set_field_code
      self.code ||= format_name
    end

    def set_display_order
      self.display_order ||= section.present? && section.fields.maximum(:display_order).to_i + 1
    end

    def set_milestone
      self.milestone = section.milestone if section
    end

    def set_mapping_field_type
      return unless field_type == 'mapping_field'

      event_mapping_field = self.class.roots.find { |obj| obj[:code] == mapping_field }
      self.mapping_field_type = event_mapping_field.present? && event_mapping_field[:field_type]
      self.color_required = event_mapping_field.present? && event_mapping_field[:color_required]
    end
end
