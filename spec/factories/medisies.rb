# frozen_string_literal: true

FactoryBot.define do
  factory :medisy do
    name { FFaker::Name.name }
    url  { "https://medisys.newsbrief.eu/rss/?" }
    program
  end
end
