# == Schema Information
#
# Table name: event_types
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EventType < ApplicationRecord
  has_many :events
  belongs_to :user
  has_many :form_types

  validates :name, presence: true
end
