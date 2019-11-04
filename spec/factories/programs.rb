FactoryBot.define do
  factory :program do
    name    { FFaker::Name.name }
    creator { create(:creator, :system_admin) }
  end
end
