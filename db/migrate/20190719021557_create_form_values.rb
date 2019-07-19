class CreateFormValues < ActiveRecord::Migration[5.2]
  def change
    create_table :form_values do |t|
      t.integer :event_id
      t.integer :form_id
      t.integer :submitter_id
      t.string  :priority

      t.timestamps
    end
  end
end
