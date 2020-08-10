class AddFinalEventTypeIdToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :final_event_type_id, :integer
  end
end
