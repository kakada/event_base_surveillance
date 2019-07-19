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
end
