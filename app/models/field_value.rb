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

  # It is required when validate relevant_field in nested attributes
  # Because on create event or event_milestone, fv.valueable is nil
  # @Todo: need to refactor
  attr_accessor :tmp_valueable

  mount_uploader :image, ImageUploader
  mount_uploader :file, FileUploader

  belongs_to :field
  belongs_to :valueable, polymorphic: true, optional: true

  serialize :properties, Hash

  delegate :field_type, to: :field, allow_nil: true
  delegate :name, to: :field, prefix: :field, allow_nil: true
  delegate :validations, to: :field, prefix: false, allow_nil: true

  # Validation
  before_validation :set_location_value, if: -> { field_type == 'Fields::LocationField' }
  before_validation :cleanup_values
  before_validation :assign_type, if: -> { field_type.present? }

  # Callback
  after_save :handle_mapping_field, if: -> { field_type == 'Fields::MappingField' }
  after_save :assign_event_date,    if: -> { field_code == 'event_date' && valueable_type == 'Event' }

  # History
  audited associated_with: :valueable

  def es_value
    value
  end

  def html_tag
    value.to_s
  end

  private
    def assign_event_date
      valueable.update_attributes(event_date: es_value)
    end

    def assign_type
      self.type = "FieldValues::#{field_type.split('::').last}"
    end

    def set_location_value
      return if Field.roots.pluck(:code).include? field_code

      clear_locations
      codes = %w[province_id district_id commune_id village_id].map { |co| properties[co] }
      code = codes[codes.find_index('').to_i - 1]

      return self.value = '' if code.blank?

      self.value = "Pumi::#{Location.location_kind(code).titlecase}".constantize.find_by_id(code).try(:address_km)
    end

    def clear_locations
      clear_next = false
      %w[province_id district_id commune_id village_id].map do |code|
        next properties[code] = '' if clear_next == true
        next if properties[code].present?

        clear_next = true
      end
    end

    def handle_mapping_field
      fv = valueable.event.field_values.find_or_initialize_by(field_id: field.parent.id)
      fv.field_code ||= field.parent.code
      fv.value = value.downcase.split(' ').join('_')
      fv.color = field.parent.field_options.find_by('LOWER(value)= ?', fv.value).try(:color) if field.parent.field_options.present?
      fv.save

      handle_tracking(fv)
    end

    def handle_tracking(field_value)
      return unless field_value.field.tracking?

      event = valueable.event
      return event.tracings.create(field_id: field_value.field_id, field_value: field_value.value, type: 'Tracings::TextTracing') if field_value.field_type != 'Fields::IntegerField'

      tracking_codes = event.milestone.fields.tracking.number.pluck(:code)
      fvs = event.field_values.select { |field_v| tracking_codes.include? field_v.field_code }.pluck(:field_code, :value).to_h
      props = {}
      tracking_codes.each do |code|
        props[code] = fvs[code] || 0
      end

      event.tracings.create(properties: props, type: 'Tracings::NumberTracing')
    end

    def cleanup_values
      return if values.blank?

      self.values = values.reject(&:blank?)
    end
end
