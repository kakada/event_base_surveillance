# frozen_string_literal: true

# == Schema Information
#
# Table name: chat_groups
#
#  id         :bigint           not null, primary key
#  chat_type  :string           default("group")
#  is_active  :boolean          default(TRUE)
#  provider   :string
#  reason     :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chat_id    :string
#  program_id :integer
#

class ChatGroup < ApplicationRecord
  has_many :notification_chat_groups
  has_many :notifications, through: :notification_chat_groups

  scope :telegrams, -> { where(provider: "Telegram") }
  scope :actives, -> { where(is_active: true) }

  TELEGRAM_CHAT_TYPES = %w[group supergroup]
  TELEGRAM_SUPER_GROUP = "supergroup"
  TELEGRAM_GROUP = "group"
end
