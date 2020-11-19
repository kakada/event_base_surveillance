# frozen_string_literal: true

class AddConcludeEventTypeIdToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :conclude_event_type_id, :integer
  end
end
