# frozen_string_literal: true

FactoryBot.define do
  factory :medisys_category do
    name  { FFaker::Name.name }
  end
end
