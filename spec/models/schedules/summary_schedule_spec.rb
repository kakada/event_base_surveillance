# frozen_string_literal: true

require "rails_helper"

RSpec.describe Schedules::SummarySchedule, type: :model do
  it { is_expected.to belong_to(:program) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:message) }
  it { is_expected.to validate_presence_of(:interval_type) }
  it { is_expected.to validate_presence_of(:follow_up_hour) }
  it { is_expected.to validate_presence_of(:emails) }

  it { is_expected.to validate_numericality_of(:follow_up_hour).only_integer }
  it { is_expected.to validate_numericality_of(:follow_up_hour).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(23) }

  describe "before_validation, set_interval_value_and_channel" do
    let(:schedule) { build(:summary_schedule, interval_value: nil) }

    before { schedule.valid? }

    it { expect(schedule.interval_value).to eq(1) }
  end

  describe "#reached_time?" do
    let!(:schedule) { build(:summary_schedule) }

    context "now is reached_time" do
      before {
        allow(schedule).to receive(:follow_up_hour).and_return(Time.zone.now.hour)
        allow(schedule).to receive(:reached_day?).and_return(true)
      }

      it { expect(schedule.reached_time?).to be_truthy }
    end

    context "now is not reach yet" do
      before {
        allow(schedule).to receive(:follow_up_hour).and_return(Time.zone.now.hour + 1)
        allow(schedule).to receive(:reached_day?).and_return(true)
      }

      it { expect(schedule.reached_time?).to be_falsey }
    end

    context "now is over the schedule time" do
      before {
        allow(schedule).to receive(:follow_up_hour).and_return(Time.zone.now.hour - 1)
        allow(schedule).to receive(:reached_day?).and_return(true)
      }

      it { expect(schedule.reached_time?).to be_falsey }
    end
  end

  describe "#reached_day?" do
    let(:schedule) { build(:summary_schedule) }

    context "day" do
      before {
        schedule.interval_type = "day"
      }

      it { expect(schedule.reached_day?).to be_truthy }
    end

    context "week" do
      before {
        schedule.interval_type = "week"
      }

      it "returns true" do
        allow(schedule).to receive(:date_index).and_return(Time.zone.now.wday)

        expect(schedule.reached_day?).to be_truthy
      end

      it "returns false" do
        allow(schedule).to receive(:date_index).and_return(Time.zone.now.wday + 1)

        expect(schedule.reached_day?).to be_falsey
      end
    end

    context "month" do
      before {
        schedule.interval_type = "month"
      }

      it "returns true" do
        allow(schedule).to receive(:date_index).and_return(Time.zone.now.mday)

        expect(schedule.reached_day?).to be_truthy
      end

      it "returns false" do
        allow(schedule).to receive(:date_index).and_return(Time.zone.now.mday + 1)

        expect(schedule.reached_day?).to be_falsey
      end
    end
  end
end
