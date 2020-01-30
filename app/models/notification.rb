# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id           :bigint           not null, primary key
#  milestone_id :integer
#  message      :text
#  provider     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Notification < ApplicationRecord
  self.inheritance_column = :provider

  # belongs_to :milestone
  belongs_to :message
  has_many :notification_chat_groups
  has_many :chat_groups, through: :notification_chat_groups

  accepts_nested_attributes_for :notification_chat_groups, allow_destroy: true

  scope :telegrams, -> { where(provider: 'Telegram') }

  validates :message, presence: true

  def notify_groups(_message)
    raise 'Abstract Method'
  end

  # Class Methods
  def self.providers
    %w[Telegram]
  end
end
