# frozen_string_literal: true

module ScheduleMessages
  class EventInterpreter
    def initialize(schedule, event)
      @schedule = schedule
      @event = event
    end

    def load(field)
      if self.respond_to?(field.to_sym)
        self.send(field.to_sym)
      else
        @event.send(field.to_sym)
      end
    end

    def event_url
      url = Rails.application.routes.url_helpers.event_url(@event, host: ENV['HOST_URL'])

      "<a href='#{url}'>#{url}</a>"
    end
  end
end
