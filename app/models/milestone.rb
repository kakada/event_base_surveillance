# frozen_string_literal: true

# == Schema Information
#
# Table name: milestones
#
#  id            :bigint           not null, primary key
#  program_id    :integer
#  name          :string
#  display_order :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Milestone < ApplicationRecord
  belongs_to :program
  has_many   :fields, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validate :validate_unique_field_name
  validate :validate_unique_field_type_location
  accepts_nested_attributes_for :fields, allow_destroy: true, reject_if: ->(attributes) { attributes['name'].blank? }

  private

  def validate_unique_field_name
    validate_uniqueness_of_in_memory(fields, %i[name], 'duplicate')
  end

  def validate_unique_field_type_location
    return if fields.select { |field| field.field_type == 'location' }.length < 2

    errors.add :field_type, 'location cannot be more than one'
  end
end
