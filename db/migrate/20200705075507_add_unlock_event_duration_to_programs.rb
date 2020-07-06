class AddUnlockEventDurationToPrograms < ActiveRecord::Migration[5.2]
  def change
    add_column :programs, :unlock_event_duration, :integer, default: 7
  end
end
