# frozen_string_literal: true

# == Schema Information
#
# Table name: event_type_webhooks
#
#  id            :bigint           not null, primary key
#  event_type_id :integer
#  webhook_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class EventTypeWebhook < ApplicationRecord
  belongs_to :event_type
  belongs_to :webhook
end
