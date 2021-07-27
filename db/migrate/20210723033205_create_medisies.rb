# frozen_string_literal: true

class CreateMedisies < ActiveRecord::Migration[5.2]
  def change
    create_table :medisies do |t|
      t.string :url
      t.string :name
      t.integer :program_id
      t.timestamps
    end
  end
end
