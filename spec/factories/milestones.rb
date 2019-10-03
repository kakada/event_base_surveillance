FactoryBot.define do
  factory :milestone do
    name    { FFaker::Name.name }
    program

    trait :root do
      name       { 'New' }
      is_default { true }

      after :create do |milestone|
        Field.roots.each do |field|
          create(:field, field.merge(milestone_id: milestone.id))
        end
      end
    end
  end
end
