# frozen_string_literal: true

class CreateProgramTelegramNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :program_telegram_notifications, id: :uuid do |t|
      t.integer :program_id
      t.integer :user_id

      t.timestamps
    end
  end
end
