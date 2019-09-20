# frozen_string_literal: true

# == Schema Information
#
# Table name: chat_groups
#
#  id         :bigint           not null, primary key
#  title      :string
#  chat_id    :integer
#  is_active  :boolean          default(TRUE)
#  reason     :text
#  provider   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class ChatGroup < ApplicationRecord
  has_many :notification_chat_groups
  has_many :notifications, through: :notification_chat_groups

  scope :telegrams, -> { where(provider: 'Telegram') }
  scope :actives, -> { where(is_active: true) }
end
