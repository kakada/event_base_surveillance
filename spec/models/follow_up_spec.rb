# frozen_string_literal: true

require "rails_helper"

RSpec.describe FollowUp, type: :model do
  describe "#after_create, send_notification_async" do
    let!(:event) { create(:event) }
    let!(:creator) { event.creator }
    let(:follow_up) { build(:follow_up, event: event) }

    before {
      creator.telegram_chat_id = "-123"
    }

    it { expect { follow_up.save }.to change(EmailAdapterWorker.jobs, :size).by(1) }
    it { expect { follow_up.save }.to change(TelegramAdapterWorker.jobs, :size).by(1) }
  end
end
