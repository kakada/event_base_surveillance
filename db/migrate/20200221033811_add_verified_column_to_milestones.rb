# frozen_string_literal: true

class AddVerifiedColumnToMilestones < ActiveRecord::Migration[5.2]
  def up
    add_column :milestones, :verified, :boolean, default: false
    migrate_verified_milestone
  end

  def down
    remove_column :milestones, :verified
  end

  private
    def migrate_verified_milestone
      Milestone.where(name: 'Verification').each do |milestone|
        milestone.update_attributes(verified: true)
      end
    end
end
