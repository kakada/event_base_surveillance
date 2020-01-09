class CreateEventLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :event_logs do |t|
      t.string  :event_uuid
      t.string  :risk_level
      t.text    :properties
      t.timestamps
    end
  end
end
