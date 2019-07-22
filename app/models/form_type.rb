# == Schema Information
#
# Table name: forms
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

  accepts_nested_attributes_for :fields, allow_destroy: true, reject_if: lambda { |attributes| attributes['name'].blank? }
end
