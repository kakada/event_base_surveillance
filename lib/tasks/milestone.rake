# frozen_string_literal: true

namespace :milestone do
  desc 'migrate verified milestone'
  task migrate_verified: :environment do
    Milestone.where(name: 'Verification').each do |milestone|
      milestone.update_attributes(verified: true)
    end
  end

  desc 'migrate milestone flag'
  task migrate_flag: :environment do
    statuses = [
      { col: 'is_default', status: 'root' },
      { col: 'verified', status: 'verified' },
      { col: 'final', status: 'final' }
    ]

    statuses.each do |item|
      Milestone.where("#{item[:col]} = ?", true).each do |milestone|
        milestone.update_attributes(status: item[:status].to_sym)
      end
    end
  end

  desc 'migrate event_date to datetime'
  task migrate_end_date_field_type_to_datetime: :environment do
    program = Program.find_by name: "GDAHP"
    milestones = program.milestones.where(name: ["Investigation", "Intervention/Response"])

    milestones.each do |milestone|
      update_field_type_to_datetime(milestone)
    end
  end

  private
    def update_field_type_to_datetime(milestone)
      fields = milestone.fields.where(code: 'end_date')

      fields.each do |field|
        field.update(field_type: 'Fields::DateTimeField')
        field.field_values.update_all(type: 'FieldValues::DateTimeField')
      end
    end
end
