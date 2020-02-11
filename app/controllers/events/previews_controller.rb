# frozen_string_literal: true

module Events
  class PreviewsController < ::ApplicationController
    before_action :assign_event

    def show
      render pdf: "event_#{@event.id}"
    end

    private

    def assign_event
      @event = Event.find(params[:event_id])
    end
  end
end
