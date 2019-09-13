class CreateTelegramNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_notifications do |t|
      t.integer  :milestone_id
      t.string   :chat_ids, array: true
      t.text     :message

      t.timestamps
    end
  end
end
