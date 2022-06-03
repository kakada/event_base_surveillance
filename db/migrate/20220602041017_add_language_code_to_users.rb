class AddLanguageCodeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :language_code, :string, default: 'km'
  end
end
