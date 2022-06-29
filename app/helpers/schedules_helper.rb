# frozen_string_literal: true

module SchedulesHelper
  def status_html(enabled)
    return "<span class='text-success'>#{t('shared.active')}</span>" if enabled

    "<span class='text-danger'>#{t('shared.inactive')}</span>"
  end

  def schedule_types
    [
      {
        type: "Schedules::EventSchedule",
        label: t("schedule.new_event_schedule"),
        icon: "<i class='fa-regular fa-calendar-check'></i>"
      },
      { type: "Schedules::SummarySchedule",
        label: t("schedule.new_summary_schedule"),
        icon: "<i class='fa-regular fa-clipboard'></i>"
      }
    ]
  end
end
