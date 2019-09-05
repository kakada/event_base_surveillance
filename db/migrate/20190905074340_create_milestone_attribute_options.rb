class CreateMilestoneAttributeOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :milestone_attribute_options do |t|
      t.integer :milestone_attribute_id
      t.string  :name
      t.string  :value
      t.string  :color

      t.timestamps
    end
  end
end
