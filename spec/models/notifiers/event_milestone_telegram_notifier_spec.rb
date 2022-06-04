# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifiers::EventMilestoneTelegramNotifier, type: :model do
  let!(:em)      { create(:event_milestone, :verification) }
  let!(:creator) { em.event.creator }

  context "event" do
    let!(:event)   { em.event }
    let!(:program) { event.program }
    let!(:message) { create(:message, milestone: event.milestone) }
    let!(:telegram_notification) { create(:telegram_notification, :with_chat_groups, message: message) }
    let(:notifier) { Notifiers::EventMilestoneTelegramNotifier.new(event) }

    describe "#enabled?" do
      context "program enable_telegram is true and message has telegram notification" do
        before {
          allow(program).to receive(:enable_telegram?).and_return(true)
        }

        it { expect(notifier.enabled?).to be_truthy }
      end

      context "program enable_telegram is false and message has telegram notification" do
        before {
          allow(program).to receive(:enable_telegram?).and_return(false)
        }

        it { expect(notifier.enabled?).to be_falsey }
      end
    end

    describe "#recipients" do
      it { expect(notifier.recipients).to eq(telegram_notification.chat_groups.actives.map(&:chat_id)) }
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
      let!(:telegram_bot) { build(:telegram_bot, program: program, token: '123:ABC') }

      it { expect(notifier.bot_token).to eq("123:ABC") }
    end
  end

  context "event milestone" do
    let!(:program) { em.program }
    let!(:message) { create(:message, milestone: em.milestone) }
    let!(:telegram_notification) { create(:telegram_notification, :with_chat_groups, message: message) }
    let(:notifier) { Notifiers::EventMilestoneTelegramNotifier.new(em) }

    describe "#enabled?" do
      context "program enable_telegram is true and message has telegram notification" do
        before {
          allow(program).to receive(:enable_telegram?).and_return(true)
        }

        it { expect(notifier.enabled?).to be_truthy }
      end

      context "program enable_telegram is false and message has telegram notification" do
        before {
          allow(program).to receive(:enable_email_notification?).and_return(false)
        }

        it { expect(notifier.enabled?).to be_falsey }
      end
    end

    describe "#recipients" do
      it { expect(notifier.recipients).to eq(telegram_notification.chat_groups.actives.map(&:chat_id)) }
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
      let!(:telegram_bot) { build(:telegram_bot, program: program, token: '123:ABC') }

      it { expect(notifier.bot_token).to eq("123:ABC") }
    end
  end
end
