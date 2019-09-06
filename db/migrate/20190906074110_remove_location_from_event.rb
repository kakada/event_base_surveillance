class RemoveLocationFromEvent < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :location, :string, default: nil
  end
end
