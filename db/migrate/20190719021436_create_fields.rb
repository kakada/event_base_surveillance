class CreateFields < ActiveRecord::Migration[5.2]
  def change
    create_table :fields do |t|
      t.string    :name, null: false
      t.string    :field_type
      t.integer   :form_type_id
      t.boolean   :required

      t.timestamps
    end
  end
end
