class CreateFieldValues < ActiveRecord::Migration[5.2]
  def change
    create_table :field_values do |t|
      t.integer :form_id
      t.integer :field_id
      t.string  :value
      t.text    :properties
      t.string  :image

      t.timestamps
    end
  end
end
