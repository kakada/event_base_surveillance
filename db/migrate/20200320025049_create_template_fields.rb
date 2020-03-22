class CreateTemplateFields < ActiveRecord::Migration[5.2]
  def change
    create_table :template_fields do |t|
      t.integer :template_id
      t.integer :field_id
      t.integer :display_order

      t.timestamps
    end
  end
end
