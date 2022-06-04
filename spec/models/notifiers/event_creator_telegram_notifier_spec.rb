# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifiers::EventCreatorTelegramNotifier, type: :model do
  let!(:em)      { create(:event_milestone, :verification) }
  let!(:creator) { em.event.creator }
  let!(:message) { "Event {{event_uuid}}: There is a new milestone('{{milestone_name}}') has been created by user {{submitter_email}}. Click <a href='{{event_url}}'>here</a> to view event detail in CamEMS" }
  let(:notifier) { Notifiers::EventCreatorTelegramNotifier.new(em, message) }

  describe '#enabled?' do
    before {
      creator.telegram_chat_id = "-123"
      allow(::TelegramBot).to receive(:has_system_bot?).and_return(true)
    }

    context "notification_channels has telegram" do
      before {
        creator.notification_channels = ['telegram']
      }

      it { expect(notifier.enabled?).to be_truthy }
    end


    context "notification_channels has only email" do
      before {
        creator.notification_channels = ['email']
      }

      it { expect(notifier.enabled?).to be_falsey }
    end
  end

  describe "#recipients" do
    before {
      creator.telegram_chat_id = '-123'
    }

    it { expect(notifier.recipients).to eq([creator.telegram_chat_id]) }
  end

  describe "#display_message" do
    before {
      allow_any_instance_of(EventMilestoneMessageInterpreter).to receive(:interpreted_message).and_return("test")
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
