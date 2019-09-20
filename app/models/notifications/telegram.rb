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
      chat_groups.each do |group|
        ::Telegram.bot.send_message(chat_id: group.chat_id, text: sms)
      end
    end
  end
end
