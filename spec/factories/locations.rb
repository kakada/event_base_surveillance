FactoryBot.define do
  factory :location do
    code { "01" }
    name_en { "Banteay Meanchey" }
    name_km { "បន្ទាយមានជ័យ" }
    geopoint { nil }
    parent_id { nil }
    kind { "province" }
  end
end
