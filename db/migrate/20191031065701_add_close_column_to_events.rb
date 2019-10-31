class AddCloseColumnToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :close, :boolean, default: false
  end
end
