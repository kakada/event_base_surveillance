# frozen_string_literal: true

FactoryBot.define do
  factory :client_app do
    name        { FFaker::Name.name }
    ip_address  { FFaker::Internet.ip_v4_address }
    permissions { ['read', 'write'] }
    active      { true }
    program     { create(:program) }

    trait :permission_read do
      permissions { ['read'] }
    end

    trait :permission_write do
      permissions { ['write'] }
    end
  end
end
