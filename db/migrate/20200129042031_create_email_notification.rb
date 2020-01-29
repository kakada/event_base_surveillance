# frozen_string_literal: true

class CreateEmailNotification < ActiveRecord::Migration[5.2]
  def change
    create_table :email_notifications do |t|
      t.integer :milestone_id
      t.integer :message_id
      t.text :emails

      t.timestamps
    end
  end
end
