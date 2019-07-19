class CreateForms < ActiveRecord::Migration[5.2]
  def change
    create_table :forms do |t|
      t.string  :name, null: false
      t.integer :event_type_id
      t.integer :display_order

      t.timestamps
    end
  end
end
