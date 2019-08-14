class MapsController < ApplicationController
  before_action :set_date_range
  def index
    events = Event.where(options).group(:latitude, :longitude, :event_type_id).count
    @event_data = build_event_data(events)
    @event_types = EventType.all
    @event_type_id = params[:event_type]
  end

  private
  def build_event_data(events)
    event_data = []
    events.each do |data, value|
      event_type = EventType.find(data[2])

      data = {
        event_id: event_type.id,
        event_type: event_type.name,
        color: event_type.color,
        count: value,
        lat: data[0],
        lng: data[1]
      }
      event_data << data
    end

    event_data
  end

  def options
    option = {}
    option.merge!({ event_type_id: params[:event_type]}) if params[:event_type].present?
    option.merge!({ event_date: @start_date..@end_date })
  end

  def set_date_range
    if params[:daterange].present?
      @start_date = Date.strptime(params[:daterange].split(' - ')[0], "%m/%d/%Y")
      @end_date = Date.strptime(params[:daterange].split(' - ')[1], "%m/%d/%Y")
    else
      @start_date = Time.zone.today - 30
      @end_date = Time.zone.today
    end
  end
end
