class TelegramNotification < ApplicationRecord
  belongs_to :milestone
  has_many   :telegram_notifications_groups
  has_many   :telegram_groups, through: :telegram_notifications_groups

  def notify_groups
    telegram_groups.each do |group|
      Telegram.bot.send_message(chat_id: group.chat_id, text: message)
    end
  end
end
