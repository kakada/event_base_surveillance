class AddZoomLevelToPrograms < ActiveRecord::Migration[5.2]
  def change
    add_column :programs, :national_zoom_level, :integer, default: 7
    add_column :programs, :provincial_zoom_level, :integer, default: 10
  end
end
