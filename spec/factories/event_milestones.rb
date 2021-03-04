# frozen_string_literal: true

FactoryBot.define do
  factory :event_milestone do
    program
    event     { create(:event, program: program) }
    submitter { create(:submitter, program: program) }
    milestone { create(:milestone, program: program) }

    trait :verification do
      milestone { create(:milestone, :verification, program: program) }

      field_values_attributes {
        [
          { field_id: milestone.fields.find_by(code: 'conducted_at').id, field_code: 'conducted_at', value: Date.today },
        ]
      }
    end

    trait :risk_assessment_with_field_values do
      milestone { create(:milestone, :risk_assessment, program: program) }

      field_values_attributes {
        [
          { field_id: milestone.fields.find_by(code: 'conducted_at').id, field_code: 'conducted_at', value: Date.tomorrow },
          { field_id: milestone.fields.find_by(name: '# of Male').id, value: 3 },
          { field_id: milestone.fields.find_by(name: '# of Female').id, value: 2 },
          { field_id: milestone.fields.find_by(name: 'Risk Level').id, value: 'High' }
        ]
      }
    end
  end
end
