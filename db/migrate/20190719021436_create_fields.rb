class CreateFields < ActiveRecord::Migration[5.2]
  def change
    create_table :fields do |t|
      t.string    :name, null: false
      t.string    :field_type
      t.boolean   :required
      t.string    :mapping_field
      t.string    :mapping_field_type
      t.integer   :display_order
      t.references :fieldable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
