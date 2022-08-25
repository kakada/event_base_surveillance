# frozen_string_literal: true

class AddSignInTypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :sign_in_type, :integer, default: 1
  end
end
