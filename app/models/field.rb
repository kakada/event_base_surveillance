# == Schema Information
#
# Table name: fields
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  filed_type :string
#  min        :integer
#  max        :integer
#  required   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Field < ApplicationRecord
end
