class RemoveValueColumnFromEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :value
    add_column    :events, :number_of_case, :integer
    add_column    :events, :number_of_death, :integer
  end
end
