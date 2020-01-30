class AddColumnTrackingToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :tracking, :boolean, default: false
  end
end
