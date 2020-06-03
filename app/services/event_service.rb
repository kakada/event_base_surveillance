# frozen_string_literal: true

require 'csv'

class EventService
  attr_reader :template

  def initialize(events, template_id)
    @events = events
    @template = Template.find(template_id)
    @program = @template.program
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
      arr = default_columns.map { |f| f[:code] }.map { |col| event.send(col) }
      objs = [event].concat(event.event_milestones.includes(:milestone, :field_values))

      objs.each do |em|
        next if em.milestone.nil?

        em.milestone.fields.each do |field|
          fv = em.field_values.find_by field_code: field.code
          arr.push fv.try(:es_value) if template.field_ids.include? field.id
        end
      end

      arr
    end

    def default_columns
      @default_columns ||= Template.predefined_fields.select { |f| template.properties.include? f[:code] }
    end

    def build_columns
      columns = default_columns.map { |f| f[:name] }

      @program.milestones.each do |milestone|
        milestone.fields.each do |field|
          column_name = @program.milestones.size > 1 ? "#{milestone.name}(#{field.name})" : field.name
          columns.push(column_name) if template.field_ids.include? field.id
        end
      end

      columns
    end
end
