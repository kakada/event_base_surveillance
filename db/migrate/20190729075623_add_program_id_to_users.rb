class AddProgramIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :program_id, :integer
  end
end
