FactoryBot.define do
  factory :event_milestone do
    event
    submitter

    trait :risk_assessment_with_field_values do
      milestone  { create(:milestone, :risk_assessment) }

      before :create do |em|
        milestone = em.milestone
        em.program_id = em.event.program_id
        em.milestone_id = milestone.id

        field_values_attributes = [
          { field_id: milestone.fields.find_by(code: 'conducted_at').id, value: Date.today },
          { field_id: milestone.fields.find_by(name: '# of Male').id, value: 3 },
          { field_id: milestone.fields.find_by(name: '# of Female').id, value: 2 },
          { field_id: milestone.fields.find_by(name: 'Risk Level').id, value: 'High' },
        ]

        em.field_values_attributes = field_values_attributes
      end
    end
  end
end
