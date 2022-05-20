class CreateIntervalFollowUps < ActiveRecord::Migration[5.2]
  def change
    create_table :interval_follow_ups do |t|
      t.integer :duration_in_day
      t.integer :duration_in_hour
      t.boolean :enabled
      t.text    :message
      t.string  :channels, array: true, default: []
      t.integer :program_id

      t.timestamps
    end
  end
end
