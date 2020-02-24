# frozen_string_literal: true

FactoryBot.define do
  factory :event_type do
    name        { FFaker::Name.name }
    color       { FFaker::Color.hex_code }
    program
    user
  end
end
