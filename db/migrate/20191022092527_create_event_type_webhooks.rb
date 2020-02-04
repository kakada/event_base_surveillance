# frozen_string_literal: true

class CreateEventTypeWebhooks < ActiveRecord::Migration[5.2]
  def change
    create_table :event_type_webhooks do |t|
      t.integer  :event_type_id
      t.integer  :webhook_id

      t.timestamps
    end
  end
end
