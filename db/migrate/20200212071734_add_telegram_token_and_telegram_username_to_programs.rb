class AddTelegramTokenAndTelegramUsernameToPrograms < ActiveRecord::Migration[5.2]
  def change
    add_column :programs, :telegram_token, :string
    add_column :programs, :telegram_username, :string
    add_column :chat_groups, :program_id, :integer
  end
end
