# frozen_string_literal: true

namespace :field do
  desc 'migrate mapping_field_id'
  task migrate_mapping_field: :environment do
    Field.where(field_type: 'Fields::MappingField').each do |field|
      root_field = field.milestone.program.milestones.root.fields.find_by(code: field.mapping_field)
      field.mapping_field_id = root_field.id
      field.save

      root_field.field_options = field.field_options if field.field_options.present?
    end
  end
end
