# frozen_string_literal: true

class CreateFollowUps < ActiveRecord::Migration[5.2]
  def change
    create_table :follow_ups do |t|
      t.string  :event_id
      t.integer :follower_id
      t.integer :followee_id
      t.text    :message
      t.string  :channels, array: true, default: []

      t.timestamps
    end
  end
end
