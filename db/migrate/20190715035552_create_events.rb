class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events, id: false do |t|
      t.primary_key :uuid, :string, limit: 36, null: false
      t.integer :event_type_id
      t.integer :creator_id
      t.integer :program_id

      t.timestamps
    end
  end
end
