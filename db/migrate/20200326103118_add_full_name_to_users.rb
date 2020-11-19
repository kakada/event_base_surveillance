# frozen_string_literal: true

class AddFullNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :full_name, :string

    Rake::Task['user:migrate_full_name'].invoke
  end
end
