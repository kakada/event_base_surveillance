# frozen_string_literal: true

class MapsController < ApplicationController
  before_action :set_date_range

  def index
    @event_types = current_program.event_types
    @event_data = MapService.new(current_user).get_event_data(params)
  end

  private
    def set_date_range
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Time.zone.today - 29
      params[:number] = 30 if params[:start_date].blank?
      params[:date_type] = 'Day' if params[:start_date].blank?
      params[:start_date] = @start_date if params[:start_date].blank?
    end
end
