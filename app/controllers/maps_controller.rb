# frozen_string_literal: true

class MapsController < ApplicationController
  def index
    @event_types = EventType.with_shared(current_program.id).includes(:program, :program_shareds)
    @event_data = MapService.new(current_user).get_event_data(filter_params)
  end

  private
    def filter_params
      params.permit( :start_date, :end_date, event_type_ids: [] )
    end
end
