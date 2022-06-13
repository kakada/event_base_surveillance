# frozen_string_literal: true

require "rake"

class AddStatusToMilestones < ActiveRecord::Migration[5.2]
  def up
    add_column :milestones, :status, :integer

    Rake::Task["milestone:migrate_flag"].invoke
  end

  def down
    remove_column :milestones, :status
  end
end
