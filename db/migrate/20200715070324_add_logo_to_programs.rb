class AddLogoToPrograms < ActiveRecord::Migration[5.2]
  def change
    add_column :programs, :logo, :string
  end
end
