class CreateEventTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :event_types do |t|
      t.string  :name, null: false
      t.integer :user_id
      t.boolean :shared

      t.timestamps
    end
  end
end
