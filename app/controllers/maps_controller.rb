class MapsController < ApplicationController
  before_action :set_date_range
  def index
    events = Event.where(options).group(:latitude, :longitude, :event_type_id, :location).count
    @event_types = EventType.where(program_option)
    @event_data = get_event_data(events)
    @event_type_id = params[:event_type]
    @programs = Program.select(:id, :name).order(name: :asc) if current_user.system_admin?
    @provinces = Location.where(kind: 'province')
    set_location
  end

  private
  def get_event_data(events)
    event_data = []

    events.each do |data, value|
      event_type = @event_types.find { |t| t.id == data[2] }
      # event_type = EventType.find(data[2])

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

  def options
    option = {}
    option.merge!({ event_type_id: params[:event_type]}) if params[:event_type].present?
    option.merge!({ event_date: @start_date..@end_date })
    option.merge!({ province_id: params[:province_id] }) if params[:province_id].present?
    option.merge!({ district_id: params[:district_id] }) if params[:district_id].present?
    option.merge!({ commune_id: params[:commune_id] }) if params[:commune_id].present?
    option.merge!({ village_id: params[:village_id] }) if params[:village_id].present?
    option.merge! program_option
  end

  def set_date_range
    if params[:daterange].present?
      @start_date = Date.strptime(params[:daterange].split(' - ')[0], "%m/%d/%Y")
      @end_date = Date.strptime(params[:daterange].split(' - ')[1], "%m/%d/%Y")
    else
      @start_date = Time.zone.today - 29
      @end_date = Time.zone.today
    end
  end

  def program_option
    program_id = current_user.program_id || params[:program_id]
    if program_id.present? then { program_id: program_id } else {} end
  end

  def set_location
    province = Location.find(params[:province_id]) if params[:province_id].present?
    @districts = province.children if province.present?
    district = Location.find(params[:district_id]) if params[:district_id].present?
    @communes = district.children if district.present?
    commune = Location.find(params[:commune_id]) if params[:commune_id].present?
    @villages = commune.children if commune.present?
  end
end
