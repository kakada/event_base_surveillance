class CreateFormTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :form_types do |t|
      t.string  :name, null: false
      t.integer :event_type_id
      t.integer :display_order

      t.timestamps
    end
  end
end
