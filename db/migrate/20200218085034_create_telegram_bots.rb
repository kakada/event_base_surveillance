class CreateTelegramBots < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_bots do |t|
      t.string :token
      t.string :username
      t.boolean :actived, :boolean, default: false
      t.integer :program_id

      t.timestamps
    end
  end
end
