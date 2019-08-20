FactoryBot.define do
  factory :api_key do
    name        { FFaker::Name.name }
    ip_address  { FFaker::Internet.ip_v4_address }
    permissions { ['read', 'write'] }
    active      { true }
    program
  end
end
