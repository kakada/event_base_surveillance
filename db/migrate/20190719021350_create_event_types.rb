# frozen_string_literal: true

class CreateEventTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :event_types do |t|
      t.string  :name, null: false
      t.integer :user_id
      t.integer :program_id
      t.boolean :shared
      t.string  :color
      t.boolean :default, default: false

      t.timestamps
    end
  end
end
