# frozen_string_literal: true

module ScheduleMessages
  class SummaryInterpreter
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

    private
      def build_lists(milestones)
        milestones = milestones.select { |m| progress_hash.keys.include?(m.name) }
        milestones.map do |milestone|
          "<li>#{milestone.name}: <b>#{progress_hash[milestone.name]}</b> (<a href='#{events_url(milestone)}' target='_blank'>view in CamEMS</a>)</li>"
        end.join("")
      end

      def progress_hash
        @progress_hash ||= @schedule.program.events.uncloseds.joins(:field_values).where("field_values.field_code = 'progress'").where("events.updated_at <= ?", deadline).group("field_values.value").count
      end

      def deadline
        @deadline ||= Date.today - @schedule.deadline_duration_in_day.days
      end

      def events_url(milestone)
        Rails.application.routes.url_helpers.events_url(host: ENV["HOST_URL"]) + "?" + { 'progresses[]': milestone.name }.to_query
      end
  end
end
