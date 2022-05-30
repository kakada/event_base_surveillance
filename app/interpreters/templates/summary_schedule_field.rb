# frozen_string_literal: true

module Templates
  class SummaryScheduleField
    def self.all
      [
        { name: "report", code: "summary.event_report", description: event_report_description },
      ]
    end

    def self.event_report_description
      str = "<ul class='text-left'>"
      str += "<li>New: 2</li>"
      str += "<li>Verification: 2</li>"
      str += "<li>Risk assessment: 2</li>"
      str += "<li>...</li>"
      str += "</ul>"
    end
  end
end
