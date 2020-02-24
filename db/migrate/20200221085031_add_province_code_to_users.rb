# frozen_string_literal: true

class AddProvinceCodeToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :province_code, :string
    migrate_user_province_code
  end

  def down
    remove_column :users, :province_code
  end

  private
    def migrate_user_province_code
      User.where(role: ['staff', 'guest']).each do |user|
        user.update_attributes(province_code: 'all')
      end
    end
end
