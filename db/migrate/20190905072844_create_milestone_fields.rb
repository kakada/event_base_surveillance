class CreateMilestoneFields < ActiveRecord::Migration[5.2]
  def change
    create_table :milestone_fields do |t|
      t.integer   :milestone_id
      t.string    :name, null: false
      t.string    :kind
      t.boolean   :required
      t.string    :mapping_field
      t.string    :mapping_field_type
      t.integer   :display_order

      t.timestamps
    end
  end
end
