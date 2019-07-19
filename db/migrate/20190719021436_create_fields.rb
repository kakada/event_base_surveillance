class CreateFields < ActiveRecord::Migration[5.2]
  def change
    create_table :fields do |t|
      t.string    :name, null: false
      t.string    :filed_type
      t.integer   :min
      t.integer   :max
      t.boolean   :required

      t.timestamps
    end
  end
end
