# frozen_string_literal: true

class AddStatusToMilestones < ActiveRecord::Migration[5.2]
  def up
    add_column :milestones, :status, :integer
    migrate_status
  end

  def down
    remove_column :milestones, :status
  end

  private
    def migrate_status
      statuses = [
        { col: 'is_default', status: 'root' },
        { col: 'verified', status: 'verified' },
        { col: 'final', status: 'final' }
      ]

      statuses.each do |item|
        Milestone.where("#{item[:col]} = ?", true).each do |milestone|
          milestone.update_attributes(status: item[:status].to_sym)
        end
      end
    end
end
