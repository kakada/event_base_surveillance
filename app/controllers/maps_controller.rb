# frozen_string_literal: true

class MapsController < ApplicationController
  def index
    @event_types = EventType.with_shared(current_program.id)
    @event_data = MapService.new(current_user).get_event_data(params)
  end
end
