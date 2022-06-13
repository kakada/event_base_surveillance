# frozen_string_literal: true

require "rails_helper"

RSpec.describe FieldValues::DateField do
  let!(:fv)     { create(:field_value, :date) }
  let!(:event)  { fv.valueable }
  let(:field_value) { fv.type.constantize.new(fv.attributes) }

  describe "condition validate_relevant_field" do
    context "only operator exist" do
      before {
        allow(field_value.field).to receive(:validations).and_return({ operator: ">", relevant_field_code: nil })
      }

      it { expect(field_value).not_to receive(:validate_relevant_field).and_call_original }
      it { expect(field_value.valid?).to be_truthy }
    end

    context "only relevant_field_code exist" do
      before {
        allow(field_value.field).to receive(:validations).and_return({ operator: nil, relevant_field_code: "1::1::my_date" })
        field_value.valid?
      }

      it { expect(field_value).not_to receive(:validate_relevant_field).and_call_original }
      it { expect(field_value.valid?).to be_truthy }
    end

    context "both operator and relevant_field_code exist" do
      let(:section) { create(:section, name: "Secondary", milestone_id: event.milestone.id) }
      let(:field_event_date) { fv.field }
      let(:fv_event_date) { fv }

      let(:field_other_date) { create(:field, :other_date, section: section, milestone_id: event.milestone.id, validations: { operator: ">", relevant_field_code: "#{event.milestone.id}::#{field_event_date.id}::#{field_event_date.code}" }) }
      let(:fv_other_date) { fv.type.constantize.new(valueable: event, field_id: field_other_date.id, field_code: field_other_date.code, value: Date.today.to_s) }

      context "relevant_field is blank" do
        before {
          allow(fv_other_date).to receive(:relevant_field).and_return(nil)
        }

        it { expect(fv_other_date.valid?).to be_truthy }
      end

      context "relevant_field is smaller" do
        before {
          fv_event_date.value = Date.yesterday.to_s
          allow(fv_other_date).to receive(:relevant_field).and_return(fv_event_date)
        }

        it { expect(fv_other_date.valid?).to be_truthy }
      end

      context "relevant_field is bigger" do
        before {
          fv_event_date.value = Date.tomorrow.to_s
          allow(fv_other_date).to receive(:relevant_field).and_return(fv_event_date)
          allow(fv_other_date).to receive(:relevant_valueable).and_return(fv_event_date.valueable)
        }

        it { expect(fv_other_date.valid?).to be_falsey }
      end
    end
  end
end
