# frozen_string_literal: true

# == Schema Information
#
# Table name: follow_ups
#
#  id          :bigint           not null, primary key
#  channels    :string           default([]), is an Array
#  message     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_id    :string
#  followee_id :integer
#  follower_id :integer
#

class FollowUp < ApplicationRecord
  include FollowUps::Channel

  # Association
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'
  belongs_to :event

  # Callback
  after_create :send_notification_async

  # Validation
  validates :message, presence: true

  CHANNELS = %w(email telegram)

  def notify_email
    title = "CamEMS follow up case: #{event_id}"

    NotificationMailer.notify(followee.email, message, title).deliver_now
  end

  def notify_telegram
    return unless followee.telegram?

    TelegramBot.send_message(followee.telegram_chat_id, message)
  end

  private
    def send_notification_async
      FollowUpWorker.perform_async(id)
    end
end
