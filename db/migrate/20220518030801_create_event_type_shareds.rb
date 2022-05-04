class CreateEventTypeShareds < ActiveRecord::Migration[5.2]
  def change
    create_table :event_type_shareds do |t|
      t.integer :event_type_id
      t.integer :program_id

      t.timestamps
    end
  end
end
