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
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EventType < ApplicationRecord
  has_many :events, dependent: :destroy
  belongs_to :user
  has_many :form_types
  has_many :fields, as: :fieldable

  validates :name, presence: true
  validates :color, presence: true, uniqueness: { scope: [:program_id] }
  before_validation :set_program_id
  validate :validate_unique_fields, on: :create

  accepts_nested_attributes_for :fields, allow_destroy: true, reject_if: lambda { |attributes| attributes['name'].blank? }

  private

  def validate_unique_fields
    validate_uniqueness_of_in_memory(
      fields, [:name, :fieldable_id, :fieldable_type], 'duplicate')
  end

  def set_program_id
    user && self.program_id = user.program_id
  end
end
