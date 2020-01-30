class CreateTracings < ActiveRecord::Migration[5.2]
  def change
    create_table :tracings do |t|
      t.integer :field_id
      t.string  :field_value
      t.text    :properties
      t.string  :traceable_id
      t.string  :traceable_type
      t.string  :type

      t.timestamps
    end
  end
end
