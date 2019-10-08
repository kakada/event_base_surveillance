class CreateEventMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :event_milestones do |t|
      t.string  :event_uuid
      t.integer :milestone_id
      t.integer :submitter_id
      t.integer :program_id

      t.timestamps
    end
  end
end
