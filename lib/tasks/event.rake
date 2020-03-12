# frozen_string_literal: true

namespace :event do
  desc 'migrate event_date'
  task migrate_event_date: :environment do
    Event.all.includes(:field_values).each do |event|
      field_value = event.field_values.select { |fv| fv.field_code == 'event_date' }.first

      next if field_value.nil?

      event.update_attributes(event_date: field_value.es_value)
    end
  end
end
