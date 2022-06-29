# frozen_string_literal: true

module Templates
  class SummaryScheduleField
    def self.all
      [
        { name: "report", code: "summary.event_report", description: event_report_description },
      ]
    end

    def self.event_report_description
      str = "<div>There are <b>6</b> unclosed events out of a total of 10 in-progress below:</div>"
      str += "<ul class='text-left'>"
      str += "<li>New: <b>2</b> (view in CamEMS)</li>"
      str += "<li>Verification: <b>2</b> (view in CamEMS)</li>"
      str += "<li>Risk assessment: <b>2</b> (view in CamEMS)</li>"
      str += "<li>...</li>"
      str + "</ul>"
    end
  end
end
