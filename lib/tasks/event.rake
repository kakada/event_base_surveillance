# frozen_string_literal: true

namespace :event do
  desc "migrate event_date"
  task migrate_event_date: :environment do
    Event.all.includes(:field_values).each do |event|
      field_value = event.field_values.select { |fv| fv.field_code == "event_date" }.first

      next if field_value.nil?

      event.update_attributes(event_date: field_value.es_value)
    end
  end

  desc "migrate shared event"
  task migrate_shared_event: :environment do
    EventType.where(shared: true).includes(:program, :events).each do |event_type|
      event_type.program_shared_ids = event_type.program.siblings.map(&:id)

      update_share_event(event_type)
    end
  end

  private
    def update_share_event(event_type)
      event_type.events.each do |event|
        event.program_shared_ids = event_type.program_shared_ids
      end
    end
end
