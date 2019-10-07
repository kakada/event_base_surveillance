FactoryBot.define do
  factory :location do
    code { "01" }
    name_en { "Banteay Meanchey" }
    name_km { "បន្ទាយមានជ័យ" }
    kind { "province" }
    parent_id { nil }
    latitude { 13.7531914 }
    longitude { 102.989615 }
  end
end
