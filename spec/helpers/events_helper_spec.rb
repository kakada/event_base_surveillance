# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventsHelper, type: :helper do
  describe "#skip_logic_data" do
    context "has relevant value" do
      let(:field) { build(:field, relevant: "patient_gender||in||F,m") }
      let(:result) { { code: "patient_gender", operator: "in", value: "f,m" } }

      it "should return values" do
        expect(helper.skip_logic_data(field)).to eq(result)
      end
    end

    context "has no relevant value" do
      let(:field) { build(:field) }

      it "should return values" do
        expect(helper.skip_logic_data(field)).to eq(nil)
      end
    end
  end

  describe "#field_code" do
    it "should return without special character" do
      code = "was_#case123_reported?"
      field_code = "was_case123_reported"
      expect(helper.field_code(code)).to eq(field_code)
    end
  end

  describe "#form_field_class" do
    context "has no relevant field" do
      let(:field) { build(:field) }
      let(:error_message) { "can't be blank" }

      it "should return correct class" do
        expect(helper.form_field_class(field, nil)).to eq("form-group")
      end

      it "should return with error class" do
        expect(helper.form_field_class(field, error_message)).to eq("form-group form-group-invalid")
      end
    end

    context "has relevant field" do
      let(:field) { build(:field, relevant: "field||in||yes") }
      let(:error_message) { "can't be blank" }

      it "should return correct class" do
        expect(helper.form_field_class(field, nil)).to eq("form-group hidden")
      end

      it "should return with error class" do
        expect(helper.form_field_class(field, error_message)).to eq("form-group form-group-invalid hidden")
      end
    end
  end
end
