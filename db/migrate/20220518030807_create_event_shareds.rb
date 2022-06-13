# frozen_string_literal: true

class CreateEventShareds < ActiveRecord::Migration[5.2]
  def change
    create_table :event_shareds do |t|
      t.string  :event_id
      t.integer :program_id

      t.timestamps
    end
  end
end
