# frozen_string_literal: true

class AddDescriptionToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :description, :text
  end
end
