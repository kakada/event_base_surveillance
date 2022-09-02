# frozen_string_literal: true

class CreateTelegramBlackLists < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_black_lists do |t|
      t.string :chat_id

      t.timestamps
    end
  end
end
