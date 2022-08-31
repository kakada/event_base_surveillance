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
#  message_id   :integer
#

module Notifications
  class TelegramNotification < ::Notification
    def notify_groups(sms)
      chat_groups.actives.each do |group|
        ::TelegramBot.client_send_message(milestone.program.telegram_bot.token, group.chat_id, sms)
      rescue ::Telegram::Bot::Forbidden => e
        group.update_attributes(is_active: false, reason: e)
      end
    end
  end
end
