# frozen_string_literal: true

require "rails_helper"

RSpec.describe Schedules::EventSchedule, type: :model do
  it { is_expected.to validate_presence_of(:interval_type) }
  it { is_expected.to validate_presence_of(:interval_value) }
  it { is_expected.to validate_presence_of(:follow_up_hour) }

  it { is_expected.to validate_numericality_of(:follow_up_hour).only_integer }
  it { is_expected.to validate_numericality_of(:follow_up_hour).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(23) }

  describe "#reached_time?" do
    let!(:schedule) { build(:event_schedule) }

    context "now is reached_time" do
      before { allow(schedule).to receive(:follow_up_hour).and_return(Time.zone.now.hour) }

      it { expect(schedule.reached_time?).to be_truthy }
    end

    context "now is not reach yet" do
      before { allow(schedule).to receive(:follow_up_hour).and_return(Time.zone.now.hour + 1) }

      it { expect(schedule.reached_time?).to be_falsey }
    end

    context "now is over the schedule time" do
      before { allow(schedule).to receive(:follow_up_hour).and_return(Time.zone.now.hour - 1) }

      it { expect(schedule.reached_time?).to be_falsey }
    end
  end
end
