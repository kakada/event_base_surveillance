# frozen_string_literal: true

# == Schema Information
#
# Table name: field_options
#
#  id         :bigint           not null, primary key
#  field_id   :integer
#  name       :string
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FieldOption < ApplicationRecord
  belongs_to :field
end
