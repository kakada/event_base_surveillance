class RenameEventGeopointToLocation < ActiveRecord::Migration[5.2]
  def change
    rename_column :events, :geopoint, :location
  end
end
