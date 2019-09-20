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


module Notifications
  class Telegram < ::Notification
    def notify_groups(sms)
      chat_groups.actives.each do |group|
        begin
          ::Telegram.bot.send_message(chat_id: group.chat_id, text: sms)
        rescue ::Telegram::Bot::Forbidden => e
          group.update_attributes(is_active: false, reason: e)
        end
      end
    end
  end
end
