# frozen_string_literal: true

require "rails_helper"

RSpec.describe FieldValues::DateField do
  let(:fv) { create(:field_value, :integer) }
  let(:field_value) { fv.type.constantize.new(fv.attributes) }

  describe "#validate value" do
    before {
      allow(field_value.field).to receive(:required?).and_return(false)
    }

    context "blank value" do
      it "is valid" do
        field_value.value = ""
        expect(field_value.valid?).to be_truthy
      end
    end

    context "value is string of number" do
      it "is valid" do
        field_value.value = "1"
        expect(field_value.valid?).to be_truthy
      end
    end

    context "value is string" do
      it "is invalid" do
        field_value.value = "invalid number"
        expect(field_value.valid?).to be_falsey
      end
    end
  end

  describe "#validate condition from, to" do
    context "no condition from and to" do
      before {
        allow(field_value.field).to receive(:validations).and_return({})
      }

      it { expect(field_value.valid?).to be_truthy }
    end

    context "both from and to conditions are blank" do
      before {
        allow(field_value.field).to receive(:validations).and_return({ from: "", to: "" })
      }

      it { expect(field_value.valid?).to be_truthy }
    end

    context "only from condition exist" do
      before {
        allow(field_value).to receive(:validations).and_return({ from: "5", to: "" })
      }

      it "is valid" do
        field_value.value = "6"
        expect(field_value.valid?).to be_truthy
      end

      it "is invalid" do
        field_value.value = "4"
        expect(field_value.valid?).to be_falsey
      end
    end

    context "only to condition exist" do
      before {
        allow(field_value.field).to receive(:validations).and_return({ from: "", to: "5" })
      }

      it "is valid" do
        field_value.value = "4"

        expect(field_value.valid?).to be_truthy
      end

      it "is invalid" do
        field_value.value = "6"

        expect(field_value.valid?).to be_falsey
      end
    end

    context "both from and to condition exist" do
      before {
        allow(field_value.field).to receive(:validations).and_return({ from: "5", to: "6" })
      }

      it "is valid" do
        field_value.value = "5"

        expect(field_value.valid?).to be_truthy
      end

      it "is invalid" do
        field_value.value = "4"

        expect(field_value.valid?).to be_falsey
      end

      it "is invalid" do
        field_value.value = "7"

        expect(field_value.valid?).to be_falsey
      end
    end
  end
end
