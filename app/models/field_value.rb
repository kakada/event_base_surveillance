# frozen_string_literal: true

# == Schema Information
#
# Table name: field_values
#
#  id             :bigint           not null, primary key
#  field_id       :integer
#  value          :string
#  values         :text             is an Array
#  properties     :text
#  image          :string
#  valueable_type :string
#  valueable_id   :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class FieldValue < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :field
  belongs_to :valueable, polymorphic: true

  serialize :properties, Hash

  delegate :field_type, to: :field, allow_nil: true

  # Validation
  before_validation :set_location_value
  after_save :handle_mapping_field

  # History
  audited associated_with: :valueable

  private

  def set_location_value
    return if field_type != 'location'

    province = Pumi::Province.find_by_id(properties[:province_id]) if properties[:province_id].present?
    district = Pumi::District.find_by_id(properties[:district_id]) if province && properties[:district_id].present?
    commune  = Pumi::Commune.find_by_id(properties[:commune_id]) if district && properties[:commune_id].present?
    village  = Pumi::Village.find_by_id(properties[:village_id]) if commune && properties[:village_id].present?

    self.value = [province, district, commune, village].reject(&:blank?).map(&:name_km).join(',')
  end

  def handle_mapping_field
    return unless field.field_type == 'mapping_field'

    valueable.event[field.mapping_field] = value
    valueable.event.risk_color = field.field_options.find_by(value: value).color
    valueable.event.save
  end
end
