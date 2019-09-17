class CreateTelegramNotificationsGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_notifications_groups do |t|
      t.integer  :telegram_notification_id
      t.integer  :telegram_group_id
    end
  end
end
