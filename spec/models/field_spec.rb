# frozen_string_literal: true

require "rails_helper"

RSpec.describe Field, type: :model do
  it { is_expected.to belong_to(:milestone) }
  it { is_expected.to belong_to(:section) }
  it { is_expected.to have_many(:field_options).dependent(:destroy) }
  it { is_expected.to have_many(:field_values) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:section_id).with_message("already exist") }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code).scoped_to(:section_id).with_message("already exist") }
  it { is_expected.to validate_presence_of(:field_type) }
  it { is_expected.to validate_inclusion_of(:field_type).in_array(Field::FIELD_TYPES) }

  context "field_type is Fields::MappingField" do
    before { allow(subject).to receive(:field_type).and_return("Fields::MappingField") }

    context "is not skip validation" do
      before { allow(subject).to receive(:skip_validation).and_return(false) }

      it { is_expected.to validate_presence_of(:mapping_field_id) }
    end

    context "is skip validation" do
      before { allow(subject).to receive(:skip_validation).and_return(true) }

      it { is_expected.not_to validate_presence_of(:mapping_field_id) }
    end
  end

  describe ".before_validation, set_code" do
    let(:field) { build(:field, name: "Any possible to having new case?", code: nil) }

    it "sets code with clearing special character" do
      field.valid?

      expect(field.code).to eq("any_possible_to_having_new_case")
    end
  end
end
