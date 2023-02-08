# frozen_string_literal: true

module ScheduleMessages
  class SummaryInterpreter
    attr_reader :schedule

    def initialize(schedule, event = nil)
      @schedule = schedule
    end

    def load(field)
      if self.respond_to?(field.to_sym)
        self.send(field.to_sym)
      else
        field
      end
    end

    def event_report
      str = "<div>There are <b>#{progress_hash.values.sum}</b> unclosed events out of a total of #{@schedule.program.events.length} in-progress below:</div>"
      str += "<ul>"
      str += build_lists(@schedule.program.milestones)
      str + "</ul>"
    end

    def event_progressing
      data = EventProgressing.new(schedule.program_id, schedule.start_date).data

      str = "<div>There are <b>#{data.total_count}</b> changes/modifiers within #{I18n.l(schedule.start_date)} to #{I18n.l(Time.zone.now)}</div>"
      str += "<ul>"
      str += "<li>New events: <b>#{data.new_event_count}</b>#{view_in_camems('uuid': data.new_event_uuids.join(', '))}</li>"
      str += "<li>Having progress: <b>#{data.progressing_event_count}</b>#{view_in_camems('uuid': data.progressing_event_uuids.join(', '))}</li>"
      str + "</ul>"
    end

    private
      def build_lists(milestones)
        milestones = milestones.select { |m| progress_hash.keys.include?(m.name) }
        milestones.map do |milestone|
          "<li>#{milestone.name}: <b>#{progress_hash[milestone.name]}</b> #{view_in_camems('progresses[]': milestone.name)}</li>"
        end.join("")
      end

      def progress_hash
        @progress_hash ||= @schedule.program.events.uncloseds.joins(:field_values).where("field_values.field_code = 'progress'").where("events.updated_at <= ?", deadline).group("field_values.value").count
      end

      def deadline
        @deadline ||= Date.today - @schedule.deadline_duration_in_day.days
      end

      def events_url(params={})
        Rails.application.routes.url_helpers.events_url(host: ENV["HOST_URL"]) + "?" + params.to_query
      end

      def view_in_camems(params)
        "(<a href='#{events_url(params)}' target='_blank'>view in CamEMS</a>)"
      end
  end
end
