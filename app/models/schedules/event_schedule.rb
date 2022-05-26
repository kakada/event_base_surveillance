# frozen_string_literal: true

# == Schema Information
#
# Table name: schedules
#
#  id             :uuid             not null, primary key
#  channels       :string           default([]), is an Array
#  date_index     :integer
#  emails         :text
#  enabled        :boolean          default(TRUE)
#  follow_up_hour :integer
#  interval_type  :integer
#  interval_value :integer
#  message        :text
#  name           :string
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  program_id     :integer
#

module Schedules
  class EventSchedule < ::Schedule
    def send_notification_async
      events = program.events.uncloseds.reached_intervals(duration_in_day)

      events.each do |event|
        event.send_notification_async(id)
      end
    end
  end
end
