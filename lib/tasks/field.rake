# frozen_string_literal: true

namespace :field do
  desc "migrate mapping_field_id"
  task migrate_mapping_field: :environment do
    Field.where(field_type: "Fields::MappingField").each do |field|
      root_field = field.milestone.program.milestones.root.fields.find_by(code: field.mapping_field)
      field.mapping_field_id = root_field.id
      field.save

      root_field.field_options = field.field_options if field.field_options.present?
    end
  end

  desc "migrate is_milestone_datetime fields and its order"
  task migrate_is_milestone_datetime: :environment do
    migrate_fields = [
      { code: "event_date", display_order: 1 },
      { code: "report_date", display_order: 2 },
      { code: "conducted_at", display_order: 1 },
    ]

    migrate_fields.each do |field|
      fields = Field.where(code: field[:code])
      fields.update_all(is_milestone_datetime: true, milestone_datetime_order: field[:display_order])
    end
  end

  desc "migrate skip logic fields not to required"
  task migrate_skip_logic_fields_not_to_required: :environment do
    Field.where(required: true).where.not(relevant: nil).update_all(required: false)
  end

  desc "migrate field codes that have special character"
  task migrate_field_code_having_special_character: :environment do
    fields = Field.where("code ~* ?", Field::SPECIAL_CHARATER_REG_EXP)
    fields.includes(:field_values).each do |field|
      field.update_column(:code, field.code.gsub(/#{Field::SPECIAL_CHARATER_REG_EXP}/, ""))
      field.field_values.update_all(field_code: field.code)
    end
  end
end
