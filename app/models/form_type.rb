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
  has_many :fields
  has_many :forms

  validates :name, presence: true
  validate :validate_unique_fields, on: :create
  accepts_nested_attributes_for :fields, allow_destroy: true, reject_if: lambda { |attributes| attributes['name'].blank? }

  private

  def validate_unique_fields
    validate_uniqueness_of_in_memory(
      fields, [:name, :form_type_id], 'duplicate')
  end
end
