FactoryBot.define do
  factory :api_key do
    name        { FFaker::Name.name }
    ip_address  { FFaker::Internet.ip_v4_address }
  end
end
