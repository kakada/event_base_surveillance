FactoryBot.define do
  factory :webhook do
    name  { FFaker::Name.name }
    url   { FFaker::Internet.http_url }
    program

    trait :basic_auth do
      type     { 'Webhooks::BasicAuth' }
      username { FFaker::Internet.user_name }
      password { FFaker::Internet.password }
    end

    trait :token_auth do
      type     { 'Webhooks::TokenAuth' }
      token    { SecureRandom.hex }
    end
  end
end
