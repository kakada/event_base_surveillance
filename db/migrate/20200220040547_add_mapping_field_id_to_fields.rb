# frozen_string_literal: true

class AddMappingFieldIdToFields < ActiveRecord::Migration[5.2]
  def up
    add_column :fields, :mapping_field_id, :integer
    migrate_mapping_field
  end

  def down
    remove_column :fields, :mapping_field_id
  end

  private
    def migrate_mapping_field
      Field.where(field_type: 'Fields::MappingField').each do |field|
        root_field = field.milestone.program.milestones.root.fields.find_by(code: field.mapping_field)
        field.mapping_field_id = root_field.id
        field.save
      end
    end
end
