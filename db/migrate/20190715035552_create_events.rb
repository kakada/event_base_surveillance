class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :event_type_id
      t.integer :creator_id
      t.integer :value
      t.text    :description
      t.string  :location
      t.string  :geo_point
      t.text    :properties

      t.timestamps
    end
  end
end
