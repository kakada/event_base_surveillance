class MapsController < ApplicationController
  before_action :set_date_range

  def index
    events = Event.where(filter_params).group(:latitude, :longitude, :event_type_id, :location).count
    @event_types = EventType.where(program_option)
    @event_data = get_event_data(events)
    @event_type_id = params[:event_type]
    @programs = Program.select(:id, :name).order(name: :asc) if current_user.system_admin?
  end

  private
  def get_event_data(events)
    event_data = []

    events.each do |data, value|
      event_type = @event_types.find { |t| t.id == data[2] }

      data = {
        event_id: event_type.id,
        event_type: event_type.name,
        color: event_type.color,
        count: value,
        lat: data[0],
        lng: data[1],
        location: data[3]
      }
      event_data << data
    end

    event_data
  end

  def filter_params
    option = maps_params[:event] || {}
    option.merge!({ event_date: @start_date..@end_date })
    option.merge! program_option
  end

  def set_date_range
    @start_date = maps_params[:start_date].present? ? Date.parse(maps_params[:start_date]) : Time.zone.today - 29
    @end_date = maps_params[:end_date].present? ? Date.parse(maps_params[:end_date]) : Time.zone.today
  end

  def program_option
    program_id = current_user.program_id || params[:program_id]
    if program_id.present? then { program_id: program_id } else {} end
  end

  def maps_params
    params.permit(:start_date, :end_date, event: [:program_id, :province_id, :district_id, :village_id, :commune_id, :event_type])
  end
end
