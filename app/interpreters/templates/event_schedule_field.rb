# frozen_string_literal: true

module Templates
  class EventScheduleField
    def self.all
      [
        { name: "code", code: "event.uuid" },
        { name: "progress", code: "event.progress" },
        { name: "event_url", code: "event.event_url" },
        { name: "last_updated_at", code: "event.updated_at" }
      ]
    end
  end
end
