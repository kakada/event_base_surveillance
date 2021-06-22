# frozen_string_literal: true

class AddTemplateToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :template_file, :string
    add_column :fields, :template_name, :string
  end
end
