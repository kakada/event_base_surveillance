# frozen_string_literal: true

class AddSectionIdToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :section_id, :integer
    add_index :fields, [:milestone_id, :name], unique: true
    add_index :fields, [:milestone_id, :code], unique: true
  end
end
