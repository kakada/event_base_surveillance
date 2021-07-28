# frozen_string_literal: true

FactoryBot.define do
  factory :medisy do
    name { FFaker::Name.name }
    url  { FFaker::Internet.http_url }
    program
  end
end
