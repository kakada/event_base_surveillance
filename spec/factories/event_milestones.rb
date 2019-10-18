FactoryBot.define do
  factory :event_milestone do
    event
    submitter

    trait :risk_assessment_with_field_values do
      before :create do |em|
        em.program_id ||= create(:program).id
        em.milestone = create(:milestone, :risk_assessment, program: em.program)
        em.event = create(:event, program: em.program)

        field_values_attributes = [
          { field_id: em.milestone.fields.find_by(code: 'conducted_at').id, value: Date.today },
          { field_id: em.milestone.fields.find_by(name: '# of Male').id, value: 3 },
          { field_id: em.milestone.fields.find_by(name: '# of Female').id, value: 2 },
          { field_id: em.milestone.fields.find_by(name: 'Risk Level').id, value: 'High' }
        ]

        em.field_values_attributes = field_values_attributes
      end
    end
  end
end
