class CreateForms < ActiveRecord::Migration[5.2]
  def change
    create_table :forms do |t|
      t.integer :event_id
      t.integer :form_type_id
      t.integer :submitter_id
      t.date    :conducted_at
      t.string  :priority
      t.string  :source

      t.timestamps
    end
  end
end
