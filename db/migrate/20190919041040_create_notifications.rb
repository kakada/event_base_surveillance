# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer  :milestone_id
      t.text     :message
      t.string   :provider

      t.timestamps
    end
  end
end
