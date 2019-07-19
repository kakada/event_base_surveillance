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
end
