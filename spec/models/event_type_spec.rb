# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventType, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:program) }
  it { is_expected.to have_many(:events) }
  it { is_expected.to have_many(:event_type_webhooks) }
  it { is_expected.to have_many(:webhooks).through(:event_type_webhooks) }
  it { is_expected.to validate_presence_of(:name) }

  describe "validation" do
    let!(:cdc) { create(:program, name: "CDC") }
    let!(:gdaph) { create(:program, name: "GDAPH") }
    let!(:h5n1) { create(:event_type, name: "h5n1", program: cdc) }
    let(:cdc_h5n1) { build(:event_type, name: "h5n1", program: cdc) }
    let(:cdc_h5n1_upcase) { build(:event_type, name: "H5N1", program: cdc) }
    let(:gdaph_h5n1) { build(:event_type, name: "h5n1", program: gdaph) }

    it { expect(cdc_h5n1.save).to be_falsey }
    it { expect(cdc_h5n1_upcase.save).to be_falsey }
    it { expect(gdaph_h5n1.save).to be_truthy }
  end

  describe "before create, #set_code" do
    let(:h5n1) { create(:event_type, name: "H5N1") }
    let(:test_name) { create(:event_type, name: "TeST Name") }

    it { expect(h5n1.code).to eq("h5n1") }
    it { expect(test_name.code).to eq("test_name") }
  end
end
