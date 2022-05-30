class AddDeadlineDurationInDayToSchedules < ActiveRecord::Migration[5.2]
  def change
    add_column :schedules, :deadline_duration_in_day, :integer
    change_column :schedules, :emails, :text, array: true, default: []
  end
end
