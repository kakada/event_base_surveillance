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

class Form < ApplicationRecord
  belongs_to :event_type
  has_many :form_fields
  has_many :fields, through: :form_fields
  has_many :form_values

  validates :name, presence: true
end
