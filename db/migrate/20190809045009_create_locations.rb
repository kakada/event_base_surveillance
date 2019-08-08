class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations, id: false do |t|
      t.string :code, primary_key: true, null: false
      t.string :name_en, null: false
      t.string :name_km, null: false
      t.point :geopoint
      t.string :parent_id
      t.string :kind, null: false

      t.timestamps
    end
  end
end
