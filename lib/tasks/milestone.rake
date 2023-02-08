# frozen_string_literal: true

namespace :milestone do
  desc "migrate verified milestone"
  task migrate_verified: :environment do
    Milestone.where(name: "Verification").each do |milestone|
      milestone.update_attributes(verified: true)
    end
  end

  desc "migrate milestone flag"
  task migrate_flag: :environment do
    statuses = [
      { col: "is_default", status: "root" },
      { col: "verified", status: "verified" },
      { col: "final", status: "final" }
    ]

    statuses.each do |item|
      Milestone.where("#{item[:col]} = ?", true).each do |milestone|
        milestone.update_attributes(status: item[:status].to_sym)
      end
    end
  end

  # bundle exec rake milestone:migrate_date_field_to_datetime_field[GDAHP,Investigation,end_date]
  # bundle exec rake milestone:migrate_date_field_to_datetime_field[GDAHP,Intervention/Response,end_date]
  # bundle exec rake milestone:migrate_date_field_to_datetime_field[CDC,Investigation,end_date]
  desc "migrate date field to datetime field. Ex: bundle exec rake milestone:migrate_date_field_to_datetime_field[CDC,Investigation,end_date]"
  task :migrate_date_field_to_datetime_field, [:program_name, :milestone_name, :date_type_field_code] => :environment do |t, args|
    program = Program.find_by name: args.program_name
    milestone = program.milestones.find_by(name: args.milestone_name)
    update_field_type_to_datetime(milestone, args.date_type_field_code)

    puts "**Migrate successfully**"
  rescue => e
    puts e
  end

  private
    def update_field_type_to_datetime(milestone, field_code="end_date")
      fields = milestone.fields.where(code: field_code)
      target_field_type = "Fields::DateTimeField"

      fields.each do |field|
        raise "#{field.name}(#{field.field_type}) is unsupported to migrate to #{target_field_type}" unless field.migratable_to?(target_field_type)

        field.update(field_type: target_field_type)
        field.field_values.update_all(type: "FieldValues::DateTimeField")
      end
    end
end
