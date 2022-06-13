# frozen_string_literal: true

FactoryBot.define do
  factory :follow_up do
    channels    { ::FollowUp::CHANNELS }
    message     { "follow up message" }
    event
    followee    { event.creator }
    follower    { create(:user) }
  end
end
