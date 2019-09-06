# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  uuid          :string(36)       not null, primary key
#  event_type_id :integer
#  creator_id    :integer
#  program_id    :integer
#  value         :integer
#  description   :text
#  latitude      :float
#  longitude     :float
#  province_id   :string
#  district_id   :string
#  commune_id    :string
#  village_id    :string
#  event_date    :date
#  report_date   :date
#  status        :string
#  risk_level    :string
#  risk_color    :string
#  source        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Event < ApplicationRecord
  include Events::Searchable

  before_create :set_uuid

  belongs_to :event_type, optional: true
  belongs_to :creator, class_name: 'User', optional: true
  belongs_to :program
  has_many   :event_milestones, foreign_key: :event_uuid, primary_key: :uuid, dependent: :destroy
  has_many   :field_values, as: :valueable

  # History
  has_associated_audits

  # Deligation
  delegate :name, :color, to: :event_type, prefix: :event_type, allow_nil: true
  delegate :name, to: :program, prefix: true

  # Validation
  validates :value, :event_date, :report_date, presence: true
  validate  :validate_field_values, on: %i[create update]
  before_validation :set_program_id

  # Nested Attributes
  accepts_nested_attributes_for :field_values, allow_destroy: true, reject_if: lambda { |attributes|
    attributes['id'].blank? && attributes['value'].blank? && attributes['image'].blank? && attributes['values'].blank? && attributes['file'].blank?
  }
  accepts_nested_attributes_for :event_milestones, allow_destroy: true

  def conducted_at
    report_date
  end

  def location_name(reverse = false)
    (reverse ? addresses.reverse : addresses).map(&:name_km).join(',')
  end

  private

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def addresses
    province = Pumi::Province.find_by_id(province_id) if province_id.present?
    district = Pumi::District.find_by_id(district_id) if province && district_id.present?
    commune  = Pumi::Commune.find_by_id(commune_id) if district && commune_id.present?
    village  = Pumi::Village.find_by_id(village_id) if commune && village_id.present?
    [province, district, commune, village].reject(&:blank?)
  end

  def set_program_id
    creator && self.program_id = creator.program_id
  end

  def validate_field_values
    program.present? && program.milestones.first&.fields&.each do |field|
      next unless field.required?

      obj = field_values.select { |value| value.field_id == field.id }.first
      errors.add field.name.downcase, 'cannot be blank' if !obj || obj[:value].blank?
    end
  end
end
