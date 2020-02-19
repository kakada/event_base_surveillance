# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id           :bigint           not null, primary key
#  message      :text
#  milestone_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#


class Message < ApplicationRecord
  belongs_to :milestone
  has_one :telegram, class_name: 'Notifications::Telegram', dependent: :destroy
  has_one :email_notification, dependent: :destroy

  # Nested attribute
  accepts_nested_attributes_for :email_notification, allow_destroy: true
  accepts_nested_attributes_for :telegram, allow_destroy: true

  validates :message, presence: true

  def self.channels
    %i(telegram email_notification)
  end
end
