# frozen_string_literal: true

require "rake"

class AddMappingFieldIdToFields < ActiveRecord::Migration[5.2]
  def up
    add_column :fields, :mapping_field_id, :integer

    Rake::Task["field:migrate_mapping_field"].invoke
  end

  def down
    remove_column :fields, :mapping_field_id
  end
end
