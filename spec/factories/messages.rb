# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    milestone
    message { "display message" }
  end
end
