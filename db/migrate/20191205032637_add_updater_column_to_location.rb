class AddUpdaterColumnToLocation < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :updater_id, :integer
  end
end
