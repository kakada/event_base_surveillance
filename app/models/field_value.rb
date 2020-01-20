# frozen_string_literal: true

# == Schema Information
#
# Table name: field_values
#
#  id             :bigint           not null, primary key
#  field_id       :integer
#  field_code     :string
#  value          :string
#  color          :string
#  values         :text             is an Array
#  properties     :text
#  image          :string
#  file           :string
#  valueable_id   :string
#  valueable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  type           :string
#

class FieldValue < ApplicationRecord
  self.inheritance_column = :type

  mount_uploader :image, ImageUploader
  mount_uploader :file, FileUploader

  belongs_to :field
  belongs_to :valueable, polymorphic: true

  serialize :properties, Hash

  delegate :field_type, to: :field, allow_nil: true
  delegate :name, to: :field, prefix: :field, allow_nil: true
  delegate :validations, to: :field, prefix: :field, allow_nil: true

  # Validation
  before_validation :set_location_value, if: -> { field_type == 'Fields::LocationField' }
  before_validation :cleanup_values
  before_validation :assign_type, if: -> { field_type.present? }

  # Callback
  after_save :handle_mapping_field, if: -> { field_type == 'Fields::MappingField' }

  # History
  audited associated_with: :valueable

  def es_value
    value
  end

  def valid_value?
    true
  end

  def valid_condition?
    true
  end

  def html_tag
    value.to_s
  end

  private

  def assign_type
    self.type = "FieldValues::#{field_type.split('::').last}"
  end

  def set_location_value
    return if Field.roots.pluck(:code).include? field_code

    province = Pumi::Province.find_by_id(properties[:province_id]) if properties[:province_id].present?
    district = Pumi::District.find_by_id(properties[:district_id]) if province && properties[:district_id].present?
    commune  = Pumi::Commune.find_by_id(properties[:commune_id]) if district && properties[:commune_id].present?
    village  = Pumi::Village.find_by_id(properties[:village_id]) if commune && properties[:village_id].present?

    self.value = [province, district, commune, village].reverse.reject(&:blank?).map(&:name_km).join(',')
  end

  def handle_mapping_field
    fv = valueable.event.field_values.find_or_initialize_by(field_code: field.mapping_field)
    fv.field_id ||= valueable.program.milestones.root.fields.find_by(code: field.mapping_field).id
    fv.value = value.downcase.split(' ').join('_')
    fv.color = field.field_options.find_by('LOWER(value)= ?', fv.value).try(:color) if field.field_options.present?
    fv.save

    handle_tracking(fv)
  end

  def handle_tracking(field_value)
    return unless field_value.field.tracking?

    event = valueable.event
    return event.logs.create(field_id: field_value.field_id, field_value: field_value.value, type: 'Logs::TextLog') if field_value.field_type != 'Fields::IntegerField'

    tracking_codes = event.milestone.fields.tracking.number.pluck(:code)
    fvs = event.field_values.select { |field_v| tracking_codes.include? field_v.field_code }.pluck(:field_code, :value).to_h
    props = {}
    tracking_codes.each do |code|
      props[code] = fvs[code] || 0
    end

    event.logs.create(properties: props, type: 'Logs::NumberLog')
  end

  def cleanup_values
    return if values.blank?

    self.values = values.reject(&:blank?)
  end
end
