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
      str = "<div>#{I18n.t('schedule.unclosedEventWithCount', {count: progress_hash.values.sum, total_count: @schedule.program.events.length})}</div>"
      str += "<ul>"
      str += build_lists(@schedule.program.milestones)
      str + "</ul>"
    end

    def event_progressing
      data = EventProgressing.new(schedule.program_id, schedule.start_date).data

      str = "<div>#{I18n.t('schedule.progressingEventWithCount', {count: data.total_count, start_date: I18n.l(schedule.start_date), end_date: I18n.l(Time.zone.now)})}</div>"
      str += "<ul>"
      str += list_item("New event", data.new_event_count, {'uuid': data.new_event_uuids.join(', ')})
      str += list_item("Having progress", data.progressing_event_count, {'uuid': data.progressing_event_uuids.join(', ')})
      str + "</ul>"
    end

    private
      def build_lists(milestones)
        milestones = milestones.select { |m| progress_hash.keys.include?(m.name) }
        milestones.map do |milestone|
          list_item(milestone.name, progress_hash[milestone.name], {'progresses[]': milestone.name})
        end.join("")
      end

      def list_item(name, value, params)
        str = "<li><span>#{name}</span>: <b>#{value}</b> "
        str += view_in_camems(params) if value.positive?
        str + "</li>"
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
