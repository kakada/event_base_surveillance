# frozen_string_literal: true

class CreateSections < ActiveRecord::Migration[5.2]
  def change
    create_table :sections do |t|
      t.string   :name
      t.integer  :milestone_id
      t.integer  :display_order
      t.boolean  :default, default: false
      t.boolean  :display, default: true

      t.timestamps
    end
  end
end
