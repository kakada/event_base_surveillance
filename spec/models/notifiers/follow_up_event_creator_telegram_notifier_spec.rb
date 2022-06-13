# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notifiers::FollowUpEventCreatorTelegramNotifier, type: :model do
  let!(:event)    { create(:event) }
  let!(:follow_up) { create(:follow_up, event: event, message: "please check this event") }
  let!(:followee) { follow_up.followee }
  let(:notifier)  { Notifiers::FollowUpEventCreatorTelegramNotifier.new(follow_up) }

  describe "#enabled?" do
    before {
      followee.telegram_chat_id = "-123"
      allow(::TelegramBot).to receive(:has_system_bot?).and_return(true)
    }

    context "has channels telegram" do
      before {
        follow_up.channels = ["telegram"]
      }

      it { expect(notifier.enabled?).to be_truthy }
    end

    context "no channels telegram" do
      before {
        follow_up.channels = ["email"]
      }

      it { expect(notifier.enabled?).to be_falsey }
    end
  end

  describe "#recipients" do
    before {
      followee.telegram_chat_id = "-1234"
    }

    it { expect(notifier.recipients).to eq([followee.telegram_chat_id]) }
  end

  describe "#display_message" do
    it { expect(notifier.display_message).to eq(follow_up.message) }
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
