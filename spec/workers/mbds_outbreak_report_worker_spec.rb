# frozen_string_literal: true

require "rails_helper"

RSpec.describe MbdsOutbreakReportWorker, type: :worker do
  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable true }

  it "enqueues outbreak report job" do
    MbdsOutbreakReportWorker.perform_async

    expect(MbdsOutbreakReportWorker).to have_enqueued_sidekiq_job
  end

  describe "#perform" do
    context "MBDS_ENABLED is false" do
      before {
        ENV["MBDS_ENABLED"] = "false"
      }

      it "returns nil" do
        expect(subject.perform).to be_nil
      end
    end

    context "creator is nil" do
      before {
        ENV["MBDS_ENABLED"] = "true"
      }

      it "returns nil" do
        expect(subject.perform).to be_nil
      end
    end

    context "MBDS_ENABLED is true and creator is present" do
      let!(:creator) { create(:user) }
      let!(:service) { instance_double(MbdsOutbreakReportService, process: 'process') }

      before {
        ENV["MBDS_ENABLED"] = "true"
        ENV["MBDS_CREATOR_EMAIL"] = creator.email

        allow(MbdsOutbreakReportService).to receive(:new).with(creator).and_return(service)
      }

      it "process the mbds outbreak report service" do
        subject.perform

        expect(service).to have_received(:process)
      end
    end
  end
end
