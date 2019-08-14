class MapsController < ApplicationController
  def index
    events = Event.where('event_date <= ?', Date.today).where(options).group(:latitude, :longitude, :event_type_id).count
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
  end
end
