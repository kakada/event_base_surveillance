# frozen_string_literal: true

class AddProvinceCodeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :province_code, :string
  end
end
