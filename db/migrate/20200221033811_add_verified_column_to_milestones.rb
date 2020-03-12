# frozen_string_literal: true

require 'rake'

class AddVerifiedColumnToMilestones < ActiveRecord::Migration[5.2]
  def up
    add_column :milestones, :verified, :boolean, default: false

    Rake::Task['milestone:migrate_verified'].invoke
  end

  def down
    remove_column :milestones, :verified
  end
end
