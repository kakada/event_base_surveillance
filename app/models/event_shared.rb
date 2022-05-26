# frozen_string_literal: true

# == Schema Information
#
# Table name: event_shareds
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :string
#  program_id :integer
#

class EventShared < ApplicationRecord
  belongs_to :event
  belongs_to :program
end
