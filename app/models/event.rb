# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  uuid          :string(36)       not null, primary key
#  event_type_id :integer
#  creator_id    :integer
#  program_id    :integer
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
  has_many   :field_values, as: :valueable, dependent: :destroy

  # History
  has_associated_audits

  # Deligation
  delegate :name, :color, to: :event_type, prefix: :event_type, allow_nil: true
  delegate :name, to: :program, prefix: true

  # Validation
  validate :validate_field_values, on: %i[create update]
  before_validation :set_program_id

  # Scope
  default_scope { order(updated_at: :desc) }

  # Callback
  after_save :assign_geo_point
  after_save    { IndexerWorker.perform_async(:index, uuid) }
  after_destroy { IndexerWorker.perform_async(:delete, uuid) }

  # Nested Attributes
  accepts_nested_attributes_for :field_values, allow_destroy: true, reject_if: lambda { |attributes|
    attributes['id'].blank? && attributes['value'].blank? && attributes['image'].blank? && attributes['values'].blank? && attributes['file'].blank?
  }
  accepts_nested_attributes_for :event_milestones, allow_destroy: true

  def conducted_at
    field_values.find_by(field_code: 'report_date').value
  end

  def location_name(reverse = false, delimeter = ',')
    (reverse ? addresses.reverse : addresses).map(&:name_km).join(delimeter)
  end

  private

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def addresses
    arr = []
    %w[province_id district_id commune_id village_id].each do |code|
      fv = field_values.find_by(field_code: code)
      next if fv.nil? || fv.value.blank?

      klass_name = "Pumi::#{code.split('_').first.titlecase}".constantize
      arr.push(klass_name.find_by_id(fv.value))
    end

    arr
  end

  def assign_geo_point
    location_code = %w[village_id commune_id district_id province_id].map do |code|
      field_values.select { |fv| fv.field_code == code }.first.try(:value)
    end.reject(&:blank?).first

    return if location_code.blank?

    location = Location.find(location_code)
    %w[latitude longitude].each do |code|
      fv = field_values.find_or_initialize_by(field_code: code)
      fv.value = location[code]
      fv.field_id = Milestone.root.fields.find_by(code: code).id
      fv.save
    end
  end

  def set_program_id
    creator && self.program_id = creator.program_id
  end

  def validate_field_values
    program.present? && Milestone.root&.fields&.each do |field|
      next unless field.required?

      obj = field_values.select { |value| value.field_id == field.id }.first
      errors.add field.name.downcase, 'cannot be blank' if !obj || obj[:value].blank?
    end
  end
end
