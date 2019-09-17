class CreateTelegramGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_groups do |t|
      t.string   :title
      t.integer  :chat_id
      t.boolean  :is_active, default: true
      t.text     :reason

      t.timestamps
    end
  end
end
