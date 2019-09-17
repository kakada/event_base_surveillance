class TelegramGroup < ApplicationRecord
  has_many   :telegram_notifications_groups
  has_many   :telegram_notifications, through: :telegram_notifications_groups
end
