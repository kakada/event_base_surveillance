# frozen_string_literal: true

# == Schema Information
#
# Table name: event_types
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  user_id    :integer
#  program_id :integer
#  shared     :boolean
#  color      :string
#  default    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EventType < ApplicationRecord
  belongs_to :user
  belongs_to :program
  has_many :events, dependent: :destroy
  has_many :fields, as: :fieldable
  has_many :event_type_webhooks
  has_many :webhooks, through: :event_type_webhooks

  validates :name, presence: true
  validates :color, presence: true, uniqueness: { scope: [:program_id] }
  before_validation :set_program_id
  before_validation :set_color
  validate :validate_unique_fields, on: :create

  accepts_nested_attributes_for :fields, allow_destroy: true, reject_if: ->(attributes) { attributes['name'].blank? }

  private

  def validate_unique_fields
    validate_uniqueness_of_in_memory(
      fields, %i[name fieldable_id fieldable_type], 'duplicate'
    )
  end

  def set_program_id
    user && self.program_id = user.program_id
  end

  def set_color
    self.color ||= "##{SecureRandom.hex(3)}"
  end
end
