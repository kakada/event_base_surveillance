class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :event_type_id
      t.integer :creator_id

      t.timestamps
    end
  end
end
