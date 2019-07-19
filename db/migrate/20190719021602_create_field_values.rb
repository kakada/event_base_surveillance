class CreateFieldValues < ActiveRecord::Migration[5.2]
  def change
    create_table :field_values do |t|
      t.integer :field_id
      t.integer :event_id
      t.string  :value

      t.timestamps
    end
  end
end
