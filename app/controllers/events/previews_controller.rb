# frozen_string_literal: true

module Events
  class PreviewsController < ::ApplicationController
    def show
      @event = authorize Event.find(params[:event_id])

      render pdf: "event_#{@event.id}"
    end
  end
end
