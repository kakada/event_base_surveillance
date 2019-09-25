FactoryBot.define do
  factory :event do
    description   {FFaker::AWS.product_description}
    event_date    {Date.today}
    report_date   {Date.today}
    province_id   {'01'}
    program
    event_type
    creator
  end
end
