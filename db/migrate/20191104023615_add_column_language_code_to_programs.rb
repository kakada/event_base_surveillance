class AddColumnLanguageCodeToPrograms < ActiveRecord::Migration[5.2]
  def change
    add_column :programs, :language_code, :string
  end
end
