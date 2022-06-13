# frozen_string_literal: true

class AddTelegramChatIdAndTelegramUsernameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :telegram_chat_id, :string
    add_column :users, :telegram_username, :string
  end
end
