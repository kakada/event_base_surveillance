class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :event_type_id
      t.integer :creator_id
      t.integer :program_id
      t.integer :value
      t.text    :description
      t.string  :location
      t.float   :latitude
      t.float   :longitude
      t.text    :properties
      t.date    :event_date
      t.date    :report_date

      t.timestamps
    end
  end
end
