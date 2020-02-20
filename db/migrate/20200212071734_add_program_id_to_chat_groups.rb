# frozen_string_literal: true

class AddProgramIdToChatGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :chat_groups, :program_id, :integer
    remove_column :programs, :enable_telegram
  end
end
