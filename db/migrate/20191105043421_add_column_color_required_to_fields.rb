# frozen_string_literal: true

class AddColumnColorRequiredToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :color_required, :boolean, default: false
  end
end
