# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifiers::EventScheduleEmailNotifier, type: :model do
  let!(:schedule) { create(:schedule) }
  let!(:event)    { create(:event, program: schedule.program) }
  let(:notifier)  { Notifiers::EventScheduleEmailNotifier.new(schedule, event) }

  describe "#enabled?" do
    context "has channels email" do
      before {
        schedule.channels = ['email']
      }

      it { expect(notifier.enabled?).to be_truthy }
    end

    context "no channels email" do
      before {
        schedule.channels = ['telegram']
      }

      it { expect(notifier.enabled?).to be_falsey }
    end
  end

  describe "#recipients" do
    it { expect(notifier.recipients).to eq([event.creator.email]) }
  end

  describe "#display_message" do
    before {
      allow_any_instance_of(ScheduleMessageInterpreter).to receive(:interpreted_message).and_return("test")
    }

    it { expect(notifier.display_message).to eq("test") }
  end

  describe "#display_title" do
    it { expect(notifier.display_title).to eq("CamEMS follow up case: #{event.id}") }
  end

  describe "#bot_token" do
    it { expect { notifier.bot_token }.to raise_error('It is for telegram channel only') }
  end
end
