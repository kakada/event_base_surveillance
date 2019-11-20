class AddValidationToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :validations, :text
  end
end
