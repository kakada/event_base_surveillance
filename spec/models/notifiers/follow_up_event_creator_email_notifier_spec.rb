# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifiers::FollowUpEventCreatorEmailNotifier, type: :model do
  let!(:event)    { create(:event) }
  let!(:follow_up){ create(:follow_up, event: event, message: "please check this event") }
  let(:notifier)  { Notifiers::FollowUpEventCreatorEmailNotifier.new(follow_up) }

  describe "#enabled?" do
    context "has channels email" do
      before {
        follow_up.channels = ["email"]
      }

      it { expect(notifier.enabled?).to be_truthy }
    end

    context "no channels email" do
      before {
        follow_up.channels = ['telegram']
      }

      it { expect(notifier.enabled?).to be_falsey }
    end
  end

  describe "#recipients" do
    it { expect(notifier.recipients).to eq([event.creator.email]) }
  end

  describe "#display_message" do
    it { expect(notifier.display_message).to eq("please check this event") }
  end

  describe "#display_title" do
    it { expect(notifier.display_title).to eq("CamEMS follow up case: #{event.id}") }
  end

  describe "#bot_token" do
    it { expect { notifier.bot_token }.to raise_error('It is for telegram channel only') }
  end
end
