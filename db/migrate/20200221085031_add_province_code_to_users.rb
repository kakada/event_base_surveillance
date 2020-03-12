# frozen_string_literal: true

require 'rake'

class AddProvinceCodeToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :province_code, :string

    Rake::Task['user:migrate_province'].invoke
  end

  def down
    remove_column :users, :province_code
  end
end
