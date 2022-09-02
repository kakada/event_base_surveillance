# frozen_string_literal: true

FactoryBot.define do
  factory :telegram_bot do
    actived  { true }
    enabled  { true }
    token    { "1234:abcd" }
    username { "bot" }
    program
  end
end
