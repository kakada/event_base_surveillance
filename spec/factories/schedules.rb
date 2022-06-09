FactoryBot.define do
  factory :schedule do
    name  { 'Follow up Event Creator' }
    type  { Schedules::EventSchedule }
    interval_type { :day }
    interval_value { 3 }
    follow_up_hour { 12 }
    channels { Schedule::CHANNELS }
    message { "Your created event {{event.uuid}} has been keep a part for a while. Your last update date {{event.updated_at}} on step on the event is {{event.progress}}. Would you consider to update next progress? {{event.event_url}}" }
    program
  end

  factory :event_schedule, class: 'Schedules::EventSchedule' do
    name  { 'Follow up Event Creator' }
    type  { Schedules::EventSchedule }
    interval_type { :day }
    interval_value { 3 }
    follow_up_hour { 12 }
    channels { Schedule::CHANNELS }
    message { "Your created event {{event.uuid}} has been keep a part for a while. Your last update date {{event.updated_at}} on step on the event is {{event.progress}}. Would you consider to update next progress? {{event.event_url}}" }
    program
  end

  factory :summary_schedule, class: 'Schedules::SummarySchedule' do
    name  { 'Summary Schedule' }
    type  { Schedules::SummarySchedule }
    interval_type { :week }
    interval_value { nil }
    follow_up_hour { 12 }
    date_index     { 1 }
    deadline_duration_in_day { 15 }
    channels { 'email' }
    message { "{{summary.event_report}}" }
    emails {['abc@gmail.com']}
    program
  end
end
