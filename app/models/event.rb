# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  event_type_id :integer
#  creator_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Event < ApplicationRecord
  belongs_to :event_type
  belongs_to :creator, class_name: 'User'
  has_many   :forms

  delegate :name, to: :event_type, prefix: :event_type

  accepts_nested_attributes_for :forms, allow_destroy: true
end
