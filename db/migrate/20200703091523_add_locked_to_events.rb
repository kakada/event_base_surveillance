# frozen_string_literal: true

class AddLockedToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :lockable_at, :datetime
  end
end
