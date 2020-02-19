# frozen_string_literal: true

class CreateChatGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_groups do |t|
      t.string   :title
      t.integer  :chat_id
      t.boolean  :is_active, default: true
      t.text     :reason
      t.string   :provider

      t.timestamps
    end
  end
end
