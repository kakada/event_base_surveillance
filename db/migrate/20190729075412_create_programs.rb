class CreatePrograms < ActiveRecord::Migration[5.2]
  def change
    create_table :programs do |t|
      t.string :name
      t.boolean :enable_telegram, default: false

      t.timestamps
    end
  end
end
