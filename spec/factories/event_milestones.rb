FactoryBot.define do
  factory :event_milestone do
    event
    submitter
    conducted_at    { Date.today }

    trait :new do
      milestone   { create(:milestone, :new) }
    end

    trait :risk_assessment_with_field_values do
      milestone   { create(:milestone, :risk_assessment) }

      after :create do |event_milestone|
        milestone = event_milestone.milestone
        male = milestone.fields.find_by(name: '# of Male')
        female = milestone.fields.find_by(name: '# of Female')
        risk_level = milestone.fields.find_by(name: 'Risk Level')

        create(:field_value, field_id: male.id, value: 3, valueable_type: 'EventMilestone', valueable_id: event_milestone.id)
        create(:field_value, field_id: female.id, value: 2, valueable_type: 'EventMilestone', valueable_id: event_milestone.id)
        create(:field_value, field_id: risk_level.id, value: 'High', valueable_type: 'EventMilestone', valueable_id: event_milestone.id)
      end
    end
  end
end
