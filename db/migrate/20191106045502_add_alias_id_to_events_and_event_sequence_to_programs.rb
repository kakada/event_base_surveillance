class AddAliasIdToEventsAndEventSequenceToPrograms < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :alias_id, :string, limit: 50
    add_column :programs, :event_sequence, :integer
  end
end
