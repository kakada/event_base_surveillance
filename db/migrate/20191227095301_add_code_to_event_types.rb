class AddCodeToEventTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :event_types, :code, :string
  end
end
