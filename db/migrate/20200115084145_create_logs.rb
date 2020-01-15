class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.integer :field_id
      t.string  :field_value
      t.text    :properties
      t.string  :logable_id
      t.string  :logable_type
      t.string  :type

      t.timestamps
    end
  end
end
