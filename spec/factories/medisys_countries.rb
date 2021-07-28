# frozen_string_literal: true

FactoryBot.define do
  factory :medisys_country do
    code  { FFaker::Address.country_code }
  end
end
