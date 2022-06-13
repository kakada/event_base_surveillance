# frozen_string_literal: true

require "csv"

class TracingService
  def initialize(event)
    @event = event
  end

  def text_tracings
    field_ids = @event.program.fields.tracking.pluck(:id)
    tracings = get_text_tracings_by_fields(field_ids)
    tracings = add_field_created_date(tracings)

    build_field_tracings_hash(field_ids, tracings)
  end

  private
    def get_text_tracings_by_fields(field_ids)
      Tracing.text.where(field_id: field_ids).where("(traceable_id = ? AND traceable_type = 'Event') OR (traceable_id IN (?) AND traceable_type = 'EventMilestone')", @event.id, @event.event_milestone_ids.join(","))
    end

    def add_field_created_date(tracings)
      tracings.as_json.map do |tracing|
        tracing["created_date"] = I18n.l(tracing["created_at"], format: :y_m_d_h_mn)
        tracing
      end
    end

    def build_field_tracings_hash(field_ids, tracings)
      hash_obj = {}

      field_ids.each do |field_id|
        sub_tracings = tracings.select { |tracing| tracing["field_id"] == field_id }

        hash_obj[field_id] = {
          display_able: sub_tracings.length > 1,
          tracings: sub_tracings.last(5)
        }
      end

      hash_obj
    end
end
