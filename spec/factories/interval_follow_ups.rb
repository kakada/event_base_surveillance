FactoryBot.define do
  factory :interval_follow_up do
    program { create(:program) }
    enabled { true }
    duration_in_day { 3 }
    duration_in_hour { 12 }
    channels { IntervalFollowUp::CHANNELS }
  end
end
