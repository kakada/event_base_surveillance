# frozen_string_literal: true

class AddReferrerToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :referrer, :string
  end
end
