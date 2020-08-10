class AddGuidelineToEventTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :event_types, :guideline, :string
  end
end
