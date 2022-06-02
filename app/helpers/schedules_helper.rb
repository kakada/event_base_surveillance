module SchedulesHelper
  def status_html(enabled)
    return "<span class='text-success'>#{t('shared.active')}</span>" if enabled

    "<span class='text-danger'>#{t('shared.inactive')}</span>"
  end

  def display_schedule_info(schedule, label="schedule_info")
    t("schedule.#{label}",
      interval_value: "<b>#{schedule.interval_value}</b>",
      interval_type: '<b>' + t("schedule.#{schedule.interval_type}") + '</b>',
      follow_up_hour: "<b>#{schedule.follow_up_hour}:00</b>"
    )
  end
end
