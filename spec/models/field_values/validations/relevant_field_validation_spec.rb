# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FieldValues::RelevantFieldValidation do
  let!(:fv)     { create(:field_value, :date) }
  let!(:event)  { fv.valueable }
  let(:field_value) { fv.type.constantize.new(fv.attributes) }

  describe '#relevant_valueable' do
    let!(:verification)    { create(:event_milestone, :verification, event: event, program: event.program) }
    let!(:risk_assessment) { create(:event_milestone, :risk_assessment_with_field_values, event: event, program: event.program) }

    # fields
    let(:verification_conducted_at) { verification.milestone.fields.find_by code: 'conducted_at' }
    let(:risk_assessment_conducted_at) { risk_assessment.milestone.fields.find_by code: 'conducted_at' }

    # field_values
    let(:verification_conducted_on) { verification.field_values.find_by field_code: 'conducted_at' }
    let(:risk_assessment_conducted_on) { risk_assessment.field_values.find_by field_code: 'conducted_at' }
    let(:event_report_date) { event.field_values.find_by field_code: 'report_date' }

    context 'is event' do
      before {
        event_report_date.tmp_valueable = event
      }

      it { expect(event_report_date.send(:relevant_valueable)).to be_nil }
      it { expect(event_report_date.send(:relevant_collection)).to eq event.field_values }
    end

    context 'is verification' do
      let(:relevant_valueable) { verification_conducted_on.send(:relevant_valueable) }

      before {
        verification_conducted_at.update(validations: { operator: '>', relevant_field_code: "#{event.milestone.id}::#{fv.id}::event_date" })
        verification_conducted_on.tmp_valueable = verification
      }

      it { expect(relevant_valueable).to eq(event) }
      it { expect(verification_conducted_on.send(:relevant_collection)).to eq(verification.field_values.to_a + relevant_valueable.field_values.to_a) }
    end

    context 'is risk_assessment' do
      let(:relevant_valueable) { risk_assessment_conducted_on.send(:relevant_valueable) }

      before {
        risk_assessment_conducted_at.update(validations: { operator: '>', relevant_field_code: "#{verification.milestone.id}::#{verification_conducted_at.id}::conducted_at" })
        risk_assessment_conducted_on.tmp_valueable = risk_assessment
      }

      it { expect(relevant_valueable).to eq(verification) }
      it { expect(risk_assessment_conducted_on.send(:relevant_collection)).to eq(risk_assessment.field_values.to_a + relevant_valueable.field_values.to_a) }
    end
  end
end
