# frozen_string_literal: true

class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules, id: :uuid do |t|
      t.string  :name
      t.string  :type
      t.boolean :enabled, default: true
      t.text    :message
      t.integer :interval_type
      t.integer :interval_value
      t.integer :date_index
      t.integer :follow_up_hour
      t.text    :emails
      t.string  :channels, array: true, default: []
      t.integer :program_id

      t.timestamps
    end
  end
end
