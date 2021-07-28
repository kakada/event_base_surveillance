# frozen_string_literal: true

class CreateMedisysCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :medisys_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
