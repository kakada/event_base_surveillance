# frozen_string_literal: true

# == Schema Information
#
# Table name: follow_ups
#
#  id          :bigint           not null, primary key
#  channels    :string           default([]), is an Array
#  message     :text
#  resolved_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_id    :string
#  followee_id :integer
#  follower_id :integer
#

class FollowUp < ApplicationRecord
  include FollowUps::Channel

  # Association
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"
  belongs_to :event

  # Callback
  after_create :send_notification_async

  # Validation
  validates :message, presence: true

  private
    def send_notification_async
      channels.each do |channel|
        notify("Notifiers::FollowUpEventCreator#{channel.titlecase}Notifier".constantize.new(self), channel)
      end
    end
end
