# == Schema Information
#
# Table name: fields
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  field_type    :string
#  form_type_id  :integer
#  required      :boolean
#  display_order :integer
#  predefined    :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Field < ApplicationRecord
  FIELD_TYPES = %w[text integer date select_one note image location]

  belongs_to :form_type
  has_many   :field_options, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :form_type, message: 'already exist' }
  validates :field_type, presence: true, inclusion: { in: FIELD_TYPES }

  default_scope { order(display_order: :asc) }

  accepts_nested_attributes_for :field_options, allow_destroy: true, reject_if: lambda { |attributes| attributes['name'].blank? }
end
