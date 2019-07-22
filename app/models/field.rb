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
  FIELD_TYPES = %w[text_field check_box date]

  belongs_to :form_type

  validates :name, presence: true
  validates :field_type, presence: true, inclusion: { in: FIELD_TYPES }
end
