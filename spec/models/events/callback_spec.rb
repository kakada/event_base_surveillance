# frozen_string_literal: true

require "rails_helper"

RSpec.describe Events::Callback do
  describe "#after_create #notify_third_party" do
    let(:program) { create(:program) }
    let(:webhook) { create(:webhook, :basic_auth) }

    context "is enable_worker?" do
      before :each do
        @event = build(:event, program: program)
        webhook.event_type_ids = @event.event_type_id

        allow(@event).to receive(:enable_worker?).and_return(true)
        allow_any_instance_of(Notifiers::EventMilestoneTelegramNotifier).to receive(:enabled?).and_return(true)
        allow_any_instance_of(Notifiers::EventMilestoneTelegramNotifier).to receive(:recipients).and_return(["123"])
        allow_any_instance_of(Notifiers::EventMilestoneTelegramNotifier).to receive(:display_message).and_return("test")
        allow_any_instance_of(Notifiers::EventMilestoneEmailNotifier).to receive(:enabled?).and_return(true)
        allow_any_instance_of(Notifiers::EventMilestoneEmailNotifier).to receive(:recipients).and_return(["abc@email.com"])
        allow_any_instance_of(Notifiers::EventMilestoneEmailNotifier).to receive(:display_message).and_return("test")
      end

      it { expect { @event.save }.to change(TelegramAdapterWorker.jobs, :size).by(1) }
      it { expect { @event.save }.to change(EmailAdapterWorker.jobs, :size).by(1) }
      it { expect { @event.save }.to change(WebhookWorker.jobs, :size).by(1) }
    end

    context "is not enable_worker?" do
      before :each do
        @event = build(:event, program: program)
        webhook.event_type_ids = @event.event_type_id

        allow(@event).to receive(:enable_worker?).and_return(false)
        allow_any_instance_of(Event).to receive(:enable_telegram?).and_return(true)
        allow_any_instance_of(Event).to receive(:enable_email_notification?).and_return(false)
      end

      it { expect { @event.save }.to change(TelegramAdapterWorker.jobs, :size).by(0) }
      it { expect { @event.save }.to change(WebhookWorker.jobs, :size).by(0) }
      it { expect { @event.save }.to change(EmailAdapterWorker.jobs, :size).by(0) }
    end
  end
end
