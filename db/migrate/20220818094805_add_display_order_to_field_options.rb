# frozen_string_literal: true

class AddDisplayOrderToFieldOptions < ActiveRecord::Migration[5.2]
  def change
    add_column :field_options, :display_order, :integer, default: 0
  end
end
