class AddFinalColumnToMilestones < ActiveRecord::Migration[5.2]
  def change
    add_column :milestones, :final, :boolean, default: false
  end
end
