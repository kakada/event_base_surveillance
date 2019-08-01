# == Schema Information
#
# Table name: field_values
#
#  id         :bigint           not null, primary key
#  form_id    :integer
#  event_id   :integer
#  field_id   :integer
#  value      :string
#  properties :text
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FieldValue < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :field
  belongs_to :form, optional: true
  belongs_to :event, optional: true

  serialize :properties, Hash

  delegate :field_type, to: :field

  before_validation :set_location_value

  private

  def set_location_value
    return if field_type != 'location'

    province = Pumi::Province.find_by_id(properties[:province_id]) if properties[:province_id].present?
    district = Pumi::District.find_by_id(properties[:district_id]) if province && properties[:district_id].present?
    commune  = Pumi::Commune.find_by_id(properties[:commune_id]) if district && properties[:commune_id].present?
    village  = Pumi::Village.find_by_id(properties[:village_id]) if commune && properties[:village_id].present?

    self.value = [province, district, commune, village].reject(&:blank?).map(&:name_km).join(',')
  end
end
