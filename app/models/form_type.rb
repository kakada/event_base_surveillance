# frozen_string_literal: true

# == Schema Information
#
# Table name: form_types
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  event_type_id :integer
#  display_order :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class FormType < ApplicationRecord
  belongs_to :event_type
  has_many :fields, as: :fieldable
  has_many :forms

  validates :name, presence: true
  validate :validate_unique_field_name
  validate :validate_unique_field_type_location
  accepts_nested_attributes_for :fields, allow_destroy: true, reject_if: ->(attributes) { attributes['name'].blank? }

  private

  def validate_unique_field_name
    validate_uniqueness_of_in_memory(fields, %i[name fieldable_id fieldable_type], 'duplicate')
  end

  def validate_unique_field_type_location
    return if fields.select { |field| field.field_type == 'location' }.length < 2

    errors.add :field_type, 'location cannot be more than one'
  end
end
