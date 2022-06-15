# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventMilestones::NotifyEventCreatorCallback do
  describe "after_create_commit" do
    let!(:event) { create(:event) }
    let!(:event_milestone) { build(:event_milestone, :verification, event: event, program: event.program) }

    context "creator has channels" do
      before {
        allow(event.creator).to receive(:notification_channels).and_return(["email", "telegram"])
        allow(event.creator).to receive(:telegram_chat_id).and_return("-123")
      }

      it { expect { event_milestone.save }.to change(EmailAdapterWorker.jobs, :size).by(1) }
      it { expect { event_milestone.save }.to change(TelegramAdapterWorker.jobs, :size).by(1) }
    end

    context "creator no channels" do
      before {
        allow(event.creator).to receive(:notification_channels).and_return([])
      }

      it { expect { event_milestone.save }.to change(EmailAdapterWorker.jobs, :size).by(0) }
      it { expect { event_milestone.save }.to change(TelegramAdapterWorker.jobs, :size).by(0) }
    end

    context "submitter and creator are the same person" do
      before {
        event_milestone.submitter_id = event.creator_id
        allow(event.creator).to receive(:notification_channels).and_return(["email", "telegram"])
        allow(event.creator).to receive(:telegram_chat_id).and_return("-123")
      }

      it { expect { event_milestone.save }.to change(EmailAdapterWorker.jobs, :size).by(0) }
      it { expect { event_milestone.save }.to change(TelegramAdapterWorker.jobs, :size).by(0) }
    end
  end
end
