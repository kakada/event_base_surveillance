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
  has_many  :client_apps
  has_many  :events
  has_many  :event_types

  validates :name, presence: true
end
