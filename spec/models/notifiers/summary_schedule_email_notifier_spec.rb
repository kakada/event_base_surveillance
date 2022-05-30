# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifiers::SummaryScheduleEmailNotifier, type: :model do
  let!(:schedule) { create(:summary_schedule) }
  let(:notifier)  { Notifiers::SummaryScheduleEmailNotifier.new(schedule) }

  describe "#enabled?" do
    context "has channels email" do
      before {
        schedule.channels = ['email']
      }

      it { expect(notifier.enabled?).to be_truthy }
    end

    context "no channels email" do
      before {
        schedule.channels = []
      }

      it { expect(notifier.enabled?).to be_falsey }
    end
  end

  describe "#recipients" do
    it { expect(notifier.recipients).to eq(schedule.emails) }
  end

  describe "#display_message" do
    before {
      allow_any_instance_of(ScheduleMessageInterpreter).to receive(:interpreted_message).and_return("test")
    }

    it { expect(notifier.display_message).to eq("test") }
  end

  describe "#display_title" do
    it { expect(notifier.display_title).to eq("Summary Report for #{schedule.program.name}") }
  end

  describe "#bot_token" do
    it { expect { notifier.bot_token }.to raise_error("It is for telegram channel only") }
  end
end
