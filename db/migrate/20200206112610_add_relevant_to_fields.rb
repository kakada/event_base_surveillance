class AddRelevantToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :relevant, :string
  end
end