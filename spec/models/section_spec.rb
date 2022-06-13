# frozen_string_literal: true

require "rails_helper"

RSpec.describe Section, type: :model do
  it { is_expected.to belong_to(:milestone) }
  it { is_expected.to have_many(:fields).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:name) }

  describe "validation" do
    let!(:program) { create(:program) }
    let(:fields) { [ { name: "my number", field_type: "Fields::IntegerField", validations: {} }, { name: "my number", field_type: "Fields::IntegerField", validations: {} } ] }
    let(:milestone) { build(:milestone, program: program, sections_attributes: [{ name: "section", fields_attributes: fields }]) }

    context "#validate_unique_field_name" do
      it { expect(milestone.save).to be_falsy }
      it { expect(milestone.save && milestone.errors.messages[:'sections.fields']).not_to equal([]) }
    end

    context "#validate_unique_field_type_location" do
      let(:fields) { [ { name: "location1", field_type: "Fields::LocationField", validations: {} }, { name: "location2", field_type: "Fields::LocationField", validations: {} } ] }

      it { expect(milestone.save).to be_falsy }
      it { expect(milestone.save && milestone.errors.messages[:'sections.field_type']).not_to equal([]) }
    end

    describe "#validate_field_from_to" do
      context "no validations" do
        let(:fields) { [ { name: "my number", field_type: "Fields::IntegerField", validations: {} } ] }

        it { expect(create(:milestone, program: program, sections_attributes: [{ name: "section", fields_attributes: fields }])).to be_truthy }
      end

      context "has both from and to" do
        let(:fields) { [ { name: "my number", field_type: "Fields::IntegerField", validations: { from: 1, to: 2 } } ] }

        it { expect(create(:milestone, program: program, sections_attributes: [{ name: "section", fields_attributes: fields }])).to be_truthy }
      end

      context "has only from" do
        before :each do
          fields = [ { name: "my number", field_type: "Fields::IntegerField", validations: { from: 1 } } ]
          @milestone = build(:milestone, program: program, sections_attributes: [{ name: "section", fields_attributes: fields }])
        end

        it { expect(@milestone.save).to be_falsy }
      end

      context "has only to" do
        before :each do
          fields = [ { name: "my number", field_type: "Fields::IntegerField", validations: { to: 1 } } ]
          @milestone = build(:milestone, program: program, sections_attributes: [{ name: "section", fields_attributes: fields }])
        end

        it { expect(@milestone.save).to be_falsy }
      end
    end
  end
end
