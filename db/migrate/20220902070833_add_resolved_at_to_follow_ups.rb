# frozen_string_literal: true

class AddResolvedAtToFollowUps < ActiveRecord::Migration[5.2]
  def change
    add_column :follow_ups, :resolved_at, :datetime
  end
end
