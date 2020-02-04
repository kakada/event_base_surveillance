# frozen_string_literal: true

class AddUserIdToProgramAndMilestone < ActiveRecord::Migration[5.2]
  def change
    add_column :programs, :creator_id, :integer
    add_column :milestones, :creator_id, :integer
  end
end
