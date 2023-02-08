# frozen_string_literal: true

require "rails_helper"

RSpec.describe FollowUp, type: :model do
  describe "#after_create, send_notification_async" do
    let!(:event) { create(:event) }
    let(:follow_up) { build(:follow_up, event: event) }

    before {
      allow(TelegramBot).to receive(:has_system_bot?).and_return(true)
      allow(event.creator).to receive(:telegram_chat_id).and_return("-123")
    }

    it { expect { follow_up.save }.to change(EmailAdapterWorker.jobs, :size).by(1) }
    it { expect { follow_up.save }.to change(TelegramAdapterWorker.jobs, :size).by(1) }
  end
end
