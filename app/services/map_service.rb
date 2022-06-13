# frozen_string_literal: true

class MapService
  def initialize(user)
    @user = user
    @event_types = EventType.with_shared(user.program_id).includes(:program_shareds, program: :fields)
  end

  def get_event_data(params = {})
    events_hash = Pundit.policy_scope(@user, Event.filter(params).joins(:event_type, :location).group("locations.latitude", "locations.longitude", "events.event_type_id", "locations.name_km", "events.location_code")).count
    events_hash.map do |data, value|
      event_type = @event_types.select { |t| t.id == data[2] }.first

      data = {
        event_type: event_type,
        total_count: value,
        lat: data[0],
        lng: data[1],
        location: data[3],
        number_of_case: get_total_by("number_of_case", event_type.id, data[4]),
        number_of_death: get_total_by("number_of_death", event_type.id, data[4]),
      }

      data["number_of_hospitalized"] = get_total_by("number_of_hospitalized", event_type.id, data[4]) if has_hospitalized_field?(event_type.program)
      data
    end
  end

  private
    def has_hospitalized_field?(program)
      program.fields.map(&:code).include?("number_of_hospitalized")
    end

    def get_total_by(case_name, event_type_id, location_code)
      all_cases.select { |obj| obj["event_type_id"] == event_type_id && obj["location_code"] == location_code && obj["field_code"] == case_name }.first.try(:[], "total")
    end

    def all_cases
      sql = "SELECT event_type_id, location_code, field_code, SUM(value::decimal) AS total
        FROM field_values fv
             INNER JOIN events ev ON (ev.uuid = valueable_id AND fv.valueable_type='Event')
             INNER JOIN event_types et ON (ev.event_type_id = et.id)
        WHERE fv.field_code in ('number_of_case', 'number_of_hospitalized', 'number_of_death')
              AND (ev.program_id=#{@user.program_id} OR et.shared=true)
        GROUP BY event_type_id, location_code, field_code"

      @all_cases ||= ActiveRecord::Base.connection.execute(sql).to_a
    end
end
