class AddIsMilestoneDatetimeToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :is_milestone_datetime, :boolean, default: false
    add_column :fields, :milestone_datetime_order, :integer
  end
end
