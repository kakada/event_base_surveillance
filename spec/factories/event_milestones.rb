# frozen_string_literal: true

FactoryBot.define do
  factory :event_milestone do
    program
    event     { create(:event, program: program) }
    submitter { create(:submitter, program: program)}
    milestone { create(:milestone, program: program)}

    trait :risk_assessment_with_field_values do
      milestone { create(:milestone, :risk_assessment, program: program) }

      field_values_attributes {
        [
          { field_id: milestone.fields.find_by(code: 'conducted_at').id, value: Date.today },
          { field_id: milestone.fields.find_by(name: '# of Male').id, value: 3 },
          { field_id: milestone.fields.find_by(name: '# of Female').id, value: 2 },
          { field_id: milestone.fields.find_by(name: 'Risk Level').id, value: 'High' }
        ]
      }
    end
  end
end
