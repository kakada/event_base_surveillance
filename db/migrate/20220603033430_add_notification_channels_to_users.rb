class AddNotificationChannelsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notification_channels, :string, array: true, default: []
  end
end
