# frozen_string_literal: true

# == Schema Information
#
# Table name: notification_chat_groups
#
#  id              :bigint           not null, primary key
#  notification_id :integer
#  chat_group_id   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#


class NotificationChatGroup < ApplicationRecord
  belongs_to :notification
  belongs_to :chat_group
end
