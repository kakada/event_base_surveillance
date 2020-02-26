# frozen_string_literal: true

class MapService
  def initialize(user)
    @user = user
    @program = user.program
    @event_types = @program.event_types
  end

  def get_event_data(params)
    data_by_field_code = query_group_by_field_code
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
        number_of_case: data_by_field_code.select{ |obj| obj['event_type_id'] == event_type.id && obj['location_code'] == data[4] && obj['field_code'] == 'number_of_case' }.first.try(:[], 'total'),
        number_of_death: data_by_field_code.select{ |obj| obj['event_type_id'] == event_type.id && obj['location_code'] == data[4] && obj['field_code'] == 'number_of_death' }.first.try(:[], 'total'),
        number_of_hospitalized: data_by_field_code.select{ |obj| obj['event_type_id'] == event_type.id && obj['location_code'] == data[4] && obj['field_code'] == 'number_of_hospitalized' }.first.try(:[], 'total')
      }
    end
  end

  private
    # https://stackoverflow.com/questions/20926615/postgresql-aggregate-sum-with-condition
    def query_group_by_field_code
      sql= "SELECT event_type_id, location_code, field_code,
        SUM(value::decimal) AS total
      FROM (
        SELECT fv.*, ev.*
        FROM   field_values fv, events ev
        WHERE  ev.uuid = fv.valueable_id
               AND fv.valueable_type='Event'
               AND ev.program_id = #{@program.id}
               AND (fv.field_code='number_of_case' OR field_code='number_of_hospitalized' OR field_code='number_of_death')
      ) as Alias
      GROUP  BY event_type_id, location_code, field_code";

      ActiveRecord::Base.connection.execute(sql).to_a
    end
end
