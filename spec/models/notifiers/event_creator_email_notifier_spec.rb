# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifiers::EventCreatorEmailNotifier, type: :model do
  let!(:em)      { create(:event_milestone, :verification) }
  let!(:creator) { em.event.creator }
  let!(:message) { "Event {{event_uuid}}: There is a new milestone('{{milestone_name}}') has been created by user {{submitter_email}}. Click <a href='{{event_url}}'>here</a> to view event detail in CamEMS" }
  let(:notifier) { Notifiers::EventCreatorEmailNotifier.new(em, message) }

  describe '#enabled?' do
    context "notification_channels has email" do
      before {
        creator.notification_channels = ['email']
      }

      it { expect(notifier.enabled?).to be_truthy }
    end

    context "notification_channels has only telegram" do
      before {
        creator.notification_channels = ['telegram']
      }

      it { expect(notifier.enabled?).to be_falsey }
    end
  end

  describe "#recipients" do
    before {
      creator.notification_channels = ['email']
    }

    it { expect(notifier.recipients).to eq([creator.email]) }
  end

  describe "#display_message" do
    before {
      allow_any_instance_of(EventMilestoneMessageInterpreter).to receive(:interpreted_message).and_return("test")
    }

    it { expect(notifier.display_message).to eq("test") }
  end

  describe "#display_title" do
    it { expect(notifier.display_title).to eq("CamEMS Notification: Event #{em.event_uuid}") }
  end

  describe "#bot_token" do
    it { expect { notifier.bot_token }.to raise_error('It is for telegram channel only') }
  end
end
