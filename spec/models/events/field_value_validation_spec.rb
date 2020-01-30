# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::FieldValueValidation do
  describe '#validate_required_field' do
    let!(:program) { create(:program) }
    let!(:event) { create(:event, program: program) }
    let!(:milestone) { create(:milestone, program: program) }

    context 'valid' do
      let!(:conducted_at) {
        {
          field_id: milestone.fields.find_by(code: 'conducted_at').id,
          field_code: 'conducted_at',
          value: Date.today.to_s
        }
      }

      let(:event_milestone) { build(:event_milestone, program: program, milestone: milestone, event: event, field_values_attributes: [conducted_at]) }

      it { expect(event_milestone.save).to be_truthy }
    end

    context 'invalid' do
      before :each do
        @event_milestone = build(:event_milestone, program: program, milestone: milestone, event: event, field_values_attributes: [])
        @event_milestone.save
      end

      it { expect(@event_milestone.save).to be_falsy }
      it { expect(@event_milestone.errors[:'conducted at']).not_to be_blank }
    end
  end

  describe '#validate_field_value_datatype' do
    let!(:program) { create(:program) }
    let!(:event) { create(:event, program: program) }
    let!(:my_number_field) { { name: 'my_number', field_type: 'Fields::IntegerField', validations: {from: 1, to: 3} } }
    let!(:milestone) { create(:milestone, program: program, fields_attributes: [my_number_field]) }
    let!(:conducted_at) {
      {
        field_id: milestone.fields.find_by(code: 'conducted_at').id,
        field_code: 'conducted_at',
        value: Date.today.to_s
      }
    }

    let(:my_number) {
      {
        field_id: milestone.fields.find_by(code: 'my_number').id,
        field_code: 'my_number',
        value: 1
      }
    }

    let(:event_milestone) { build(:event_milestone, program: program, milestone: milestone, event: event, field_values_attributes: [conducted_at, my_number]) }

    context 'valid data type' do
      it { expect(event_milestone.save).to be_truthy }
    end

    context 'valid number range' do
      before :each do
        my_number[:value] = 3
      end

      it { expect(event_milestone.save).to be_truthy }
    end

    context 'invalid number range' do
      before :each do
        my_number[:value] = 0
      end

      it { expect(event_milestone.save).to be_falsy }
    end

    context 'invalid data type' do
      before :each do
        my_number[:value] = 'abc'
      end

      it { expect(event_milestone.save).to be_falsy }
    end
  end
end
