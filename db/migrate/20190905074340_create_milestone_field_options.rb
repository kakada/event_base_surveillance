class CreateMilestoneFieldOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :milestone_field_options do |t|
      t.integer :milestone_field_id
      t.string  :name
      t.string  :value
      t.string  :color

      t.timestamps
    end
  end
end
