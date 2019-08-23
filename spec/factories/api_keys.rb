FactoryBot.define do
  factory :api_key do
    name        { FFaker::Name.name }
    ip_address  { FFaker::Internet.ip_v4_address }
    permissions { ['read', 'write'] }
    active      { true }
    program

    trait :permission_read do
      permissions {['read']}
    end

    trait :permission_write do
      permissions {['write']}
    end
  end
end
