class CreateEventMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :event_milestones do |t|
      t.integer :event_uuid
      t.integer :milestone_id
      t.integer :submitter_id
      t.date    :conducted_at
      t.string  :priority
      t.string  :source

      t.timestamps
    end
  end
end
