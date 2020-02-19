# frozen_string_literal: true

class CreateNotificationChatGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_chat_groups do |t|
      t.integer  :notification_id
      t.integer  :chat_group_id

      t.timestamps
    end
  end
end
