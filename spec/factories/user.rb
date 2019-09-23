FactoryBot.define do
  factory :user, aliases: [:creator, :submitter] do
    sequence(:email){|n| "user-#{n}@ebs.org"}
    password              { "password" }
    password_confirmation { "password" }
    confirmed_at          { Date.today }
    role                  {'program_admin'}
    program

    trait :system_admin do
      role    {'system_admin'}
    end

    trait :staff do
      role    {'staff'}
    end
  end
end
