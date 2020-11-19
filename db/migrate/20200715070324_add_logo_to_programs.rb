# frozen_string_literal: true

class AddLogoToPrograms < ActiveRecord::Migration[5.2]
  def change
    add_column :programs, :logo, :string
  end
end
