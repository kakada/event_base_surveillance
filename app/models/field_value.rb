# frozen_string_literal: true

# == Schema Information
#
# Table name: field_values
#
#  id             :bigint           not null, primary key
#  field_id       :integer
#  field_code     :string
#  value          :string
#  values         :text             is an Array
#  properties     :text
#  image          :string
#  file           :string
#  valueable_id   :string
#  valueable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class FieldValue < ApplicationRecord
  mount_uploader :image, ImageUploader
  mount_uploader :file, FileUploader

  belongs_to :field
  belongs_to :valueable, polymorphic: true

  serialize :properties, Hash

  delegate :field_type, :name, to: :field, allow_nil: true
  delegate :name, to: :field, prefix: :field, allow_nil: true

  # Validation
  before_validation :set_location_value, if: -> { field_type == 'location' }
  before_validation :cleanup_values
  after_save :handle_risk_level, if: -> { field.field_type == 'mapping_field' && field.mapping_field == 'risk_level' }

  # History
  audited associated_with: :valueable

  private

  def set_location_value
    province = Pumi::Province.find_by_id(properties[:province_id]) if properties[:province_id].present?
    district = Pumi::District.find_by_id(properties[:district_id]) if province && properties[:district_id].present?
    commune  = Pumi::Commune.find_by_id(properties[:commune_id]) if district && properties[:commune_id].present?
    village  = Pumi::Village.find_by_id(properties[:village_id]) if commune && properties[:village_id].present?

    self.value = [province, district, commune, village].reverse.reject(&:blank?).map(&:name_km).join(',')
  end

  def handle_risk_level
    assign_risk_level
    assign_risk_color
  end

  def assign_risk_level
    fv = valueable.event.field_values.find_or_initialize_by(field_code: 'risk_level')
    fv.value = value
    fv.field_id ||= Milestone.root.fields.find_by(code: 'risk_level').id
    fv.save
  end

  def assign_risk_color
    fv = valueable.event.field_values.find_or_initialize_by(field_code: 'risk_color')
    fv.value = field.field_options.find_by(value: value).color
    fv.field_id ||= Milestone.root.fields.find_by(code: 'risk_color').id
    fv.save
  end

  def cleanup_values
    return if values.blank?

    self.values = values.reject(&:blank?)
  end
end
