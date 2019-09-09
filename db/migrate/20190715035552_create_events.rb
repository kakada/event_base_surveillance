class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events, id: false do |t|
      t.primary_key :uuid, :string, limit: 36, null: false
      t.integer :event_type_id
      t.integer :creator_id
      t.integer :program_id
      t.integer :value
      t.text    :description
      t.string  :location
      t.float   :latitude
      t.float   :longitude
      t.string  :province_id
      t.string  :district_id
      t.string  :commune_id
      t.string  :village_id
      t.date    :event_date
      t.date    :report_date
      t.string  :status
      t.string  :risk_level
      t.string  :risk_color
      t.string  :source

      t.timestamps
    end
  end
end
