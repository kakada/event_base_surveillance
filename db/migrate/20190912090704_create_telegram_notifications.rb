class CreateTelegramNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_notifications do |t|
      t.integer  :milestone_id
      t.text     :message

      t.timestamps
    end
  end
end
