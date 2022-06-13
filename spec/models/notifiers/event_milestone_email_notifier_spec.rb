# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notifiers::EventMilestoneEmailNotifier, type: :model do
  let!(:em)      { create(:event_milestone, :verification) }
  let!(:creator) { em.event.creator }

  context "event" do
    let!(:event)   { em.event }
    let!(:program) { event.program }
    let!(:message) { create(:message, milestone: event.milestone) }
    let!(:email_notification) { create(:email_notification, message: message, emails: ["abc@gmail.com"]) }
    let(:notifier) { Notifiers::EventMilestoneEmailNotifier.new(event) }

    describe "#enabled?" do
      context "program enable_email_notification is true and message has email notification" do
        before {
          allow(program).to receive(:enable_email_notification?).and_return(true)
        }

        it { expect(notifier.enabled?).to be_truthy }
      end

      context "program enable_email_notification is false and message has email notification" do
        before {
          allow(program).to receive(:enable_email_notification?).and_return(false)
        }

        it { expect(notifier.enabled?).to be_falsey }
      end
    end

    describe "#recipients" do
      it { expect(notifier.recipients).to eq(["abc@gmail.com"]) }
    end

    describe "#display_message" do
      before {
        allow(event).to receive(:telegram_message).and_return("test")
      }

      it { expect(notifier.display_message).to eq("test") }
    end

    describe "#display_title" do
      it { expect(notifier.display_title).to eq(nil) }
    end

    describe "#bot_token" do
      it { expect { notifier.bot_token }.to raise_error("It is for telegram channel only") }
    end
  end

  context "event milestone" do
    let!(:program) { em.program }
    let!(:message) { create(:message, milestone: em.milestone) }
    let!(:email_notification) { create(:email_notification, message: message, emails: ["abc1@gmail.com"]) }
    let(:notifier) { Notifiers::EventMilestoneEmailNotifier.new(em) }

    describe "#enabled?" do
      context "program enable_email_notification is true and message has email notification" do
        before {
          allow(program).to receive(:enable_email_notification?).and_return(true)
        }

        it { expect(notifier.enabled?).to be_truthy }
      end

      context "program enable_email_notification is false and message has email notification" do
        before {
          allow(program).to receive(:enable_email_notification?).and_return(false)
        }

        it { expect(notifier.enabled?).to be_falsey }
      end
    end

    describe "#recipients" do
      it { expect(notifier.recipients).to eq(["abc1@gmail.com"]) }
    end

    describe "#display_message" do
      before {
        allow(em).to receive(:telegram_message).and_return("test1")
      }

      it { expect(notifier.display_message).to eq("test1") }
    end

    describe "#display_title" do
      it { expect(notifier.display_title).to eq(nil) }
    end

    describe "#bot_token" do
      it { expect { notifier.bot_token }.to raise_error("It is for telegram channel only") }
    end
  end
end
