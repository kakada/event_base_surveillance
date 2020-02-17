class AddProgramIdToChatGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :chat_groups, :program_id, :integer
  end
end
