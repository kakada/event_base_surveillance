# frozen_string_literal: true

require 'csv'

class EventService
  def initialize(events, program)
    @program = program
    @events = events
  end

  def export_csv
    CSV.generate(headers: true) do |csv|
      csv << build_columns

      @events.each do |event|
        csv << build_csv_record(event)
      end
    end
  end

  private

  def build_csv_record(event)
    arr = default_columns.map { |col| event.send(col) }
    objs = [event].concat(event.event_milestones.includes(:milestone, :field_values))
    objs.each do |em|
      em.milestone.fields.each do |field|
        fv = em.field_values.find_by field_code: field.code
        arr.push fv.try(:value)
      end
    end

    arr
  end

  def default_columns
    @default_columns ||= %w[uuid event_type_name program_name location_name created_at updated_at close]
  end

  def build_columns
    columns = default_columns.dup

    @program.milestones.each do |milestone|
      milestone.fields.each do |field|
        columns.push("#{milestone.format_name}.#{field.code}")
      end
    end

    columns
  end
end
