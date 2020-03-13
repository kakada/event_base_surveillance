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
      chat_groups.each do |group|
        bot.send_message(chat_id: group.chat_id, text: sms, parse_mode: :HTML)
      rescue ::Telegram::Bot::Forbidden => e
        group.update_attributes(is_active: false, reason: e)
      end
    end

    def bot
      @bot ||= ::Telegram::Bot::Client.new(milestone.program.telegram_bot.token, milestone.program.telegram_bot.username)
    end
  end
end
