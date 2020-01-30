class AddLinkUuidToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :link_uuid, :string
  end
end
