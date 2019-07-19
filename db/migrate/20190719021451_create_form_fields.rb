class CreateFormFields < ActiveRecord::Migration[5.2]
  def change
    create_table :form_fields do |t|
      t.integer :form_id
      t.integer :field_id

      t.timestamps
    end
  end
end
