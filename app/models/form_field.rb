# == Schema Information
#
# Table name: form_fields
#
#  id         :bigint           not null, primary key
#  form_id    :integer
#  field_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FormField < ApplicationRecord
  belongs_to :form
  belongs_to :field
  has_many   :form_field_values
end
