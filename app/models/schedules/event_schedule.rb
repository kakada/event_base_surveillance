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
  class EventSchedule < ::Schedule
    # Intant method
    def send_notification_async
      channels.each do |channel|
        notify_to_events(channel)
      end
    end

    def template_fields
      ::Templates::EventScheduleField.all
    end

    def reached_time?
      follow_up_hour == Time.zone.now.hour
    end

    def short_description
      description('event_schedule_short_info')
    end

    def full_description
      description('event_schedule_full_info')
    end

    def display_message(event)
      ScheduleMessageInterpreter.new(self, event).interpreted_message
    end

    def icon_html
      "<i class='fas fa-calendar-check'></i>"
    end

    def display_type
      I18n.t('schedule.event_schedule')
    end

    private
      def description(label)
        I18n.t("schedule.#{label}",
          interval_value: "<b>#{interval_value}</b>",
          interval_type: "<b>" + I18n.t("schedule.#{interval_type}") + "</b>",
          follow_up_hour: "<b>#{follow_up_hour}:00</b>"
        )
      end

      def notify_to_events(channel)
        events = program.events.uncloseds.reached_intervals(duration_in_day)

        events.each do |event|
          notify("Notifiers::EventSchedule#{channel.titlecase}Notifier".constantize.new(self, event), channel)
        end
      end
  end
end
