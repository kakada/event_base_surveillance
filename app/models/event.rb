# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  event_type_id :integer
#  creator_id    :integer
#  value         :integer
#  description   :text
#  location      :string
#  latitude      :float
#  longitude     :float
#  properties    :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Event < ApplicationRecord
  belongs_to :event_type
  belongs_to :creator, class_name: 'User'
  has_many   :forms, dependent: :destroy
  has_many   :field_values

  serialize :properties, Hash

  # Deligation
  delegate :name, to: :event_type, prefix: :event_type

  # Geo location
  geocoded_by :location

  # Vdlidation
  validates :location, presence: true
  validates :value, presence: true
  validate  :validate_field_values, on: [:create, :update]
  before_validation :set_location
  after_validation :geocode, :if => :location_changed?

  # Nested Attributes
  accepts_nested_attributes_for :field_values, allow_destroy: true, reject_if: lambda { |attributes|
    attributes['id'].blank? && attributes['value'].blank? && attributes['image'].blank?
  }

  def address
    addresses.map(&:name_km).join(' > ')
  end

  private

  def addresses
    province = Pumi::Province.find_by_id(properties[:province_id]) if properties[:province_id].present?
    district = Pumi::District.find_by_id(properties[:district_id]) if province && properties[:district_id].present?
    commune  = Pumi::Commune.find_by_id(properties[:commune_id]) if district && properties[:commune_id].present?
    village  = Pumi::Village.find_by_id(properties[:village_id]) if commune && properties[:village_id].present?
    [province, district, commune, village].reject(&:blank?)
  end

  def set_location
    self.location = addresses.map(&:name_en).join(',')
  end

  def validate_field_values
    event_type && event_type.fields.each do |field|
      next if !field.required?

      obj = field_values.select{ |value| value.field_id == field.id }.first
      if !obj || obj[:value].blank?
        errors.add field.name.downcase, "cannot be blank"
      end
    end
  end
end
