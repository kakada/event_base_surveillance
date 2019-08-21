class AddIndexToEvent < ActiveRecord::Migration[5.2]
  def change
    add_index :events, [:event_date, :program_id]
  end
end
