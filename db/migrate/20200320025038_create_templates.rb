# frozen_string_literal: true

class CreateTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :templates do |t|
      t.string  :name
      t.integer :program_id
      t.text    :properties

      t.timestamps
    end
  end
end
