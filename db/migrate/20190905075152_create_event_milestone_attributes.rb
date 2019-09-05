class CreateEventMilestoneAttributes < ActiveRecord::Migration[5.2]
  def change
    create_table :event_milestone_attributes do |t|
      t.integer :milestone_attribute_id
      t.string  :value
      t.text    :values, array: true
      t.text    :properties
      t.string  :image
      t.string  :file
      t.references :valueable, polymorphic: true, index: { name: :index_attr_on_valueable_type_and_valueable_id }

      t.timestamps
    end
  end
end
