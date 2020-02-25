# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [:creator, :submitter] do
    sequence(:email) { |n| "user-#{n}@ebs.org" }
    password              { 'password' }
    password_confirmation { 'password' }
    confirmed_at          { Date.today }
    role                  { 'program_admin' }
    program_id            { create(:program).id }

    trait :system_admin do
      role    { 'system_admin' }
      program_id  { nil }
    end

    trait :staff do
      role          { 'staff' }
      province_code { Pumi::Province.all.pluck(:id).sample }
    end

    trait :guest do
      role          { 'staff' }
      province_code { Pumi::Province.all.pluck(:id).sample }
    end
  end
end
