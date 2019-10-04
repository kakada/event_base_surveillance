class CreateFieldValues < ActiveRecord::Migration[5.2]
  def change
    create_table :field_values do |t|
      t.integer :field_id
      t.string  :field_code
      t.string  :value
      t.text    :values, array: true
      t.text    :properties
      t.string  :image
      t.string  :file
      t.string  :valueable_id
      t.string  :valueable_type

      t.timestamps
    end
  end
end
