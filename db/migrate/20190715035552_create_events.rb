class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :event_type_id
      t.integer :creator_id
      t.integer :program_id
      t.integer :value
      t.text    :description
      t.string  :location
      t.text    :properties
      t.date    :event_date
      t.date    :report_date
      t.string  :status
      t.string  :risk_level

      t.timestamps
    end
  end
end
