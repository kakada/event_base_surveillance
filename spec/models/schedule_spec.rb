# frozen_string_literal: true

require "rails_helper"

RSpec.describe Schedule, type: :model do
  it { is_expected.to belong_to(:program) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:message) }
  it { is_expected.to validate_presence_of(:interval_type) }
  it { is_expected.to validate_presence_of(:interval_value) }
  it { is_expected.to validate_presence_of(:follow_up_hour) }

  it { is_expected.to validate_numericality_of(:follow_up_hour).only_integer }
  it { is_expected.to validate_numericality_of(:follow_up_hour).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(23) }

  describe "#reached_time?" do
    let!(:schedule) { build(:schedule) }

    it { expect { schedule.reached_time? }.to raise_error("Abstract Method") }
  end

  describe "#display_message" do
    let!(:schedule) { build(:schedule) }

    it { expect { schedule.display_message }.to raise_error("Abstract Method") }
  end

  describe "#duration_in_type" do
    let!(:schedule) { build(:schedule) }

    context "day" do
      before { allow(schedule).to receive(:interval_type).and_return("day") }

      it { expect(schedule.duration_in_type).to eq(1) }
    end

    context "week" do
      before { allow(schedule).to receive(:interval_type).and_return("week") }

      it { expect(schedule.duration_in_type).to eq(7) }
    end

    context "month" do
      before { allow(schedule).to receive(:interval_type).and_return("month") }

      it { expect(schedule.duration_in_type).to eq(30) }
    end
  end
end
