# == Schema Information
#
# Table name: field_values
#
#  id         :bigint           not null, primary key
#  field_id   :integer
#  event_id   :integer
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FieldValue < ApplicationRecord
  belongs_to :field
  belongs_to :event
end
