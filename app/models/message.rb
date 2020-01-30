# frozen_string_literal: true

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
