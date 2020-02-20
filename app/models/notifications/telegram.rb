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
  class Telegram < ::Notification
    def notify_groups(sms)
      milestone && milestone.program.chat_groups.actives.each do |group|
        bot.send_message(chat_id: group.chat_id, text: sms, parse_mode: :HTML)
      rescue ::Telegram::Bot::Forbidden => e
        group.update_attributes(is_active: false, reason: e)
      end
    end

    def bot
      @bot ||= ::Telegram::Bot::Client.new(milestone.program.telegram_token, milestone.program.telegram_username)
    end
  end
end
