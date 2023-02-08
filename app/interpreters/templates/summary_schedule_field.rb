# frozen_string_literal: true

module Templates
  class SummaryScheduleField
    def self.all
      [
        { name: "report", code: "summary.event_report", description: event_report_sample },
        { name: "progressing", code: "summary.event_progressing", description: event_progressing_sample }
      ]
    end

    class << self
      private
        def event_report_sample
          str = "<div>There are <b>6</b> unclosed events out of a total of 10 in-progress below:</div>"
          str += "<ul class='text-left'>"
          str += "<li>New: <b>2</b> #{view_in_camems}</li>"
          str += "<li>Verification: <b>2</b> #{view_in_camems}</li>"
          str += "<li>Risk assessment: <b>2</b> #{view_in_camems}</li>"
          str += "<li>...</li>"
          str + "</ul>"
        end

        def event_progressing_sample
          str = "<div>There are <b>5</b> changes/modifiers within Jan 25, 2023 to Feb 01, 2023</div>"
          str += "<ul class='text-left'>"
          str += "<li>New events: <b>2</b> #{view_in_camems}</li>"
          str += "<li>Having progress: <b>3</b> #{view_in_camems}</li>"
          str += "<li>...</li>"
          str + "</ul>"
        end

        def view_in_camems
          "(<a class='text-primary'>view in CamEMS</a>)"
        end
    end
  end
end
