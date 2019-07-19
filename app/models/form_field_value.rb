# == Schema Information
#
# Table name: form_field_values
#
#  id            :bigint           not null, primary key
#  form_field_id :integer
#  event_id      :integer
#  value         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class FormFieldValue < ApplicationRecord
end
