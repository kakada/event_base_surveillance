# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  event_type_id :integer
#  creator_id    :integer
#  program_id    :integer
#  value         :integer
#  description   :text
#  location      :string
#  latitude      :float
#  longitude     :float
#  province_id   :string
#  district_id   :string
#  commune_id    :string
#  village_id    :string
#  properties    :text
#  event_date    :date
#  report_date   :date
#  status        :string
#  risk_level    :string
#  risk_color    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Event < ApplicationRecord
  belongs_to :event_type
  belongs_to :creator, class_name: 'User'
  has_many   :forms, dependent: :destroy
  has_many   :field_values, as: :valueable

  serialize :properties, Hash

  # History
  has_associated_audits

  # Deligation
  delegate :name, :color, to: :event_type, prefix: :event_type

  # Validation
  validates :location, presence: true
  validates :value, presence: true
  validates :event_date, presence: true
  validate  :validate_field_values, on: %i[create update]
  before_validation :set_location
  before_validation :set_program_id

  # Nested Attributes
  accepts_nested_attributes_for :field_values, allow_destroy: true, reject_if: lambda { |attributes|
    attributes['id'].blank? && attributes['value'].blank? && attributes['image'].blank? && attributes['values'].blank? && attributes['file'].blank?
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

  def set_program_id
    creator && self.program_id = creator.program_id
  end

  def validate_field_values
    event_type&.fields&.each do |field|
      next unless field.required?

      obj = field_values.select { |value| value.field_id == field.id }.first
      errors.add field.name.downcase, 'cannot be blank' if !obj || obj[:value].blank?
    end
  end
end
