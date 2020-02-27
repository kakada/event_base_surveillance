# frozen_string_literal: true

class MapService
  def initialize(user)
    @user = user
    @event_types = EventType.with_shared(user.program_id)
  end

  def get_event_data(params = {})
    all_cases = query_group_by_field_code
    events_hash = Pundit.policy_scope(@user, Event.filter(params).joins(:event_type, :location).group('locations.latitude', 'locations.longitude', 'events.event_type_id', 'locations.name_km', 'events.location_code')).count

    events_hash.map do |data, value|
      event_type = @event_types.select { |t| t.id == data[2] }.first

      {
        event_type_id: event_type.id,
        event_type_name: event_type.name,
        color: event_type.color,
        total_count: value,
        lat: data[0],
        lng: data[1],
        location: data[3],
        number_of_case: all_cases.select { |obj| obj['event_type_id'] == event_type.id && obj['location_code'] == data[4] && obj['field_code'] == 'number_of_case' }.first.try(:[], 'total'),
        number_of_death: all_cases.select { |obj| obj['event_type_id'] == event_type.id && obj['location_code'] == data[4] && obj['field_code'] == 'number_of_death' }.first.try(:[], 'total'),
        number_of_hospitalized: all_cases.select { |obj| obj['event_type_id'] == event_type.id && obj['location_code'] == data[4] && obj['field_code'] == 'number_of_hospitalized' }.first.try(:[], 'total')
      }
    end
  end

  private
    # https://stackoverflow.com/questions/20926615/postgresql-aggregate-sum-with-condition
    def query_group_by_field_code
      sql = "SELECT event_type_id, location_code, field_code, SUM(value::decimal) AS total
        FROM field_values fv
             INNER JOIN events ev ON (ev.uuid = valueable_id AND fv.valueable_type='Event')
             INNER JOIN event_types et ON (ev.event_type_id = et.id)
        WHERE fv.field_code in ('number_of_case', 'number_of_hospitalized', 'number_of_death')
              AND (ev.program_id=#{@user.program_id} OR et.shared=true)
        GROUP BY event_type_id, location_code, field_code"

      ActiveRecord::Base.connection.execute(sql).to_a
    end
end
