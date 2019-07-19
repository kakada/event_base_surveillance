# == Schema Information
#
# Table name: fields
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  filed_type :string
#  form_id    :integer
#  required   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Field < ApplicationRecord
  belongs_to :form

  validates :name, presence: true
end
