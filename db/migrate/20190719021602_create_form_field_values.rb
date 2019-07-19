class CreateFormFieldValues < ActiveRecord::Migration[5.2]
  def change
    create_table :form_field_values do |t|
      t.integer :form_field_id
      t.integer :event_id
      t.string  :value

      t.timestamps
    end
  end
end
