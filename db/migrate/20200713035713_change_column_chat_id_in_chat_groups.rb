# frozen_string_literal: true

class ChangeColumnChatIdInChatGroups < ActiveRecord::Migration[5.2]
  def change
    change_column :chat_groups, :chat_id, :string
    add_column    :chat_groups, :chat_type, :string, default: "group"
  end
end
