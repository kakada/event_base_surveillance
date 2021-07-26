class CreateMedisysCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :medisys_countries do |t|
      t.string :code
      t.string :image

      t.timestamps
    end
  end
end
