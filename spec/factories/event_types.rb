FactoryBot.define do
  factory :event_type do
    name        { 'H5N1' }
    color       { FFaker::Color.hex_code }
    program
    user
  end
end
