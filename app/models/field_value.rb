# == Schema Information
#
# Table name: field_values
#
#  id         :bigint           not null, primary key
#  form_id    :integer
#  field_id   :integer
#  value      :string
#  properties :text
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FieldValue < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :field
  belongs_to :form

  serialize :properties, Hash
end