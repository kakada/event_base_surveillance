class CreateMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :milestones do |t|
      t.integer  :program_id
      t.string   :name
      t.integer  :display_order
      t.boolean  :is_default, default: false

      t.timestamps
    end
  end
end
