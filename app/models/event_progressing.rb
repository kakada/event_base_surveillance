class EventProgressing
  attr_reader :start_date, :program

  def initialize(program_id, start_date)
    @program = Program.find(program_id)
    @start_date = start_date
  end

  def data
    OpenStruct.new(
      new_event_count: new_events.length,
      new_event_uuids: new_events.pluck(:uuid),
      progressing_event_count: progressing_events.length,
      progressing_event_uuids: progressing_events.pluck(:uuid),
      total_count: new_events.length + progressing_events.length
    )
  end

  def new_events
    @new_events ||= Event.where("created_at >= ? AND program_id = ?", start_date, program.id)
  end

  def progressing_events
    @progressing_events ||= Event.joins(:field_values)
                                  .where("events.created_at < ? AND events.updated_at >= ? AND events.program_id = ?", start_date, start_date, program.id)
                                  .where("field_values.field_code = 'progress' AND field_values.value <> ?", program.milestones.root.name)
  end
end
