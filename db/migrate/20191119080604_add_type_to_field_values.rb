# frozen_string_literal: true

class AddTypeToFieldValues < ActiveRecord::Migration[5.2]
  def change
    add_column :field_values, :type, :string
  end
end
