class TelegramNotification < ApplicationRecord
  belongs_to :milestone
  has_many   :telegram_notifications_groups
  has_many   :telegram_groups, through: :telegram_notifications_groups
end
