class TelegramNotificationsGroup < ApplicationRecord
  belongs_to :telegram_notification
  belongs_to :telegram_group
end
