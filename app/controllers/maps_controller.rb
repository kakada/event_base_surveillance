class MapsController < ApplicationController
  # before_action: :set_
  def index
    events = Event.where('event_date <= ?', Date.today).group(:latitude, :longitude, :event_type_id).count
    @event_data = build_event_data(events)
    @event_legend = build_event_legend
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

  def build_event_legend
    legend = []
    event_type_ids = Event.distinct.pluck(:event_type_id)
    event_types = EventType.where(id: event_type_ids)

    event_types.each do |type|
      data = {
        color: type.color,
        name: type.name
      }

      legend << data
    end

    legend
  end
end
