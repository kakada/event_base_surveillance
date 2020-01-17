# frozen_string_literal: true

# == Schema Information
#
# Table name: logs
#
#  id           :bigint           not null, primary key
#  field_id     :integer
#  field_value  :string
#  properties   :text
#  logable_id   :string
#  logable_type :string
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Log < ApplicationRecord
  belongs_to :logable, polymorphic: true
  serialize :properties, Hash

  scope :number, -> { where(type: 'Logs::NumberLog') }
  scope :text, -> { where(type: 'Logs::TextLog') }
end
