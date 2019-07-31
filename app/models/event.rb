# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  event_type_id :integer
#  creator_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Event < ApplicationRecord
  belongs_to :event_type
  belongs_to :creator, class_name: 'User'
  has_many   :forms, dependent: :destroy
  has_many   :field_values

  serialize :properties, Hash

  delegate :name, to: :event_type, prefix: :event_type

  validates :location, presence: true
  validates :value, presence: true
  validate  :validate_field_values, on: [:create, :update]

  accepts_nested_attributes_for :field_values, allow_destroy: true, reject_if: lambda { |attributes|
    attributes['id'].blank? && attributes['value'].blank? && attributes['image'].blank?
  }

  def address
    province = Pumi::Province.find_by_id(properties[:province_id]).name_km if properties[:province_id].present?
    district = Pumi::District.find_by_id(properties[:district_id]).name_km if province && properties[:district_id].present?
    commune  = Pumi::Commune.find_by_id(properties[:commune_id]).name_km if district && properties[:commune_id].present?
    village  = Pumi::Village.find_by_id(properties[:village_id]).name_km if commune && properties[:village_id].present?
    [province, district, commune, village].reject(&:blank?).join(' > ')
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
