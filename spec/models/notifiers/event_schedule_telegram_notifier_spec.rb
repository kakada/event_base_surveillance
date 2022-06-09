# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifiers::EventScheduleTelegramNotifier, type: :model do
  let!(:schedule) { create(:event_schedule) }
  let!(:event)    { create(:event, program: schedule.program) }
  let!(:creator)  { event.creator }
  let(:notifier)  { Notifiers::EventScheduleTelegramNotifier.new(schedule, event) }

  describe "#enabled?" do
    before {
      creator.telegram_chat_id = '-1234'
      allow(::TelegramBot).to receive(:has_system_bot?).and_return(true)
    }

    context "has channels telegram" do
      before {
        schedule.channels = ['telegram']
      }

      it { expect(notifier.enabled?).to be_truthy }
    end

    context "no channels telegram" do
      before {
        schedule.channels = ['email']
      }

      it { expect(notifier.enabled?).to be_falsey }
    end
  end

  describe "#recipients" do
    before {
      creator.telegram_chat_id = '-1234'
    }

    it { expect(notifier.recipients).to eq(['-1234']) }
  end

  describe "#display_message" do
    before {
      allow_any_instance_of(ScheduleMessageInterpreter).to receive(:interpreted_message).and_return("test")
    }

    it { expect(notifier.display_message).to eq("test") }
  end

  describe "#display_title" do
    it { expect(notifier.display_title).to eq(nil) }
  end

  describe "#bot_token" do
    before {
      allow(::TelegramBot).to receive(:system_bot_token).and_return("123:ABC")
    }

    it { expect(notifier.bot_token).to eq("123:ABC") }
  end
end
