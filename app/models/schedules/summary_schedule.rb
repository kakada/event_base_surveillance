# frozen_string_literal: true

# == Schema Information
#
# Table name: schedules
#
#  id                       :uuid             not null, primary key
#  channels                 :string           default([]), is an Array
#  date_index               :integer
#  deadline_duration_in_day :integer
#  emails                   :text             default([]), is an Array
#  enabled                  :boolean          default(TRUE)
#  follow_up_hour           :integer
#  interval_type            :integer
#  interval_value           :integer
#  message                  :text
#  name                     :string
#  type                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  program_id               :integer
#

module Schedules
  class SummarySchedule < ::Schedule
    # Intant method
    def send_notification_async
      channels.each do |channel|
        notify("Notifiers::SummarySchedule#{channel.titlecase}Notifier".constantize.new(self), channel)
      end
    end

    def template_fields
      ::Templates::SummaryScheduleField.all
    end

    def reached_time?
      follow_up_hour == Time.zone.now.hour && reached_day?
    end

    def reached_day?
      return true if day?
      return date_index == Time.zone.now.wday if week?

      date_index == Time.zone.now.mday
    end

    def short_description
      discription("summary_schedule_short_info")
    end

    def full_description
      discription("summary_schedule_full_info")
    end

    def display_message
      ScheduleMessageInterpreter.new(self).interpreted_message
    end

    def icon_html
      "<i class='fas fa-clipboard-list'></i>"
    end

    def display_type
      I18n.t("schedule.summary_schedule")
    end

    private
      def discription(label)
        I18n.t("schedule.#{label}",
          interval_type: "<b>" + I18n.t("schedule.#{interval_type}") + "</b>",
          follow_up_hour: "<b>#{follow_up_hour}:00</b>",
          date_index: "<b>#{display_date_index}</b>"
        )
      end

      def display_date_index
        return "" if day?
        return I18n.t("date.day_names")[date_index] if week?

        date_index
      end
  end
end
