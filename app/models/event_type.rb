# == Schema Information
#
# Table name: event_types
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EventType < ApplicationRecord
  has_many :events
  belongs_to :user
  has_many :form_types
  has_many :fields

  validates :name, presence: true
  validate :validate_unique_fields, on: :create

  accepts_nested_attributes_for :fields, allow_destroy: true, reject_if: lambda { |attributes| attributes['name'].blank? }

  private

  def validate_unique_fields
    validate_uniqueness_of_in_memory(
      fields, [:name, :form_type_id], 'duplicate')
  end
end
