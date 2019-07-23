class CreateFieldOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :field_options do |t|
      t.integer :field_id
      t.string  :name
      t.string  :value

      t.timestamps
    end
  end
end
