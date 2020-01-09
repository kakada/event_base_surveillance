# frozen_string_literal: true

# == Schema Information
#
# Table name: event_logs
#
#  id         :bigint           not null, primary key
#  event_uuid :string
#  risk_level :string
#  properties :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EventLog < ApplicationRecord
  belongs_to :event, foreign_key: :event_uuid
  serialize :properties, Hash
end
