# frozen_string_literal: true

# == Schema Information
#
# Table name: programs
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Program < ApplicationRecord
  has_many  :users
  has_many  :api_keys
  validates :name, presence: true
end
