# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventMilestone, type: :model do
  it { is_expected.to belong_to(:event).with_foreign_key(:event_uuid) }
  it { is_expected.to belong_to(:milestone) }
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:submitter).class_name("User").optional }
  it { is_expected.to have_many(:field_values).dependent(:destroy) }
  it { is_expected.to have_many(:tracings).dependent(:destroy) }

  describe "#validate_uniqueness_of milestone_id" do
    let!(:event_milestone) { create(:event_milestone, :risk_assessment_with_field_values) }
    let!(:event_milestone2) { build(:event_milestone, milestone_id: event_milestone.milestone.id, event: event_milestone.event, program: event_milestone.program) }

    it { expect(event_milestone2.save).to be_falsey }
    it { expect(event_milestone2.save && event_milestone2.errors.messages[:milestone_id]).not_to equal([]) }
  end

  describe ".after_commit" do
    describe "#set_event_conclude_event_type_id" do
      let!(:event) { create(:event) }

      context "conclude_event_type_id is nil" do
        let!(:event_milestone) { create(:event_milestone, :risk_assessment_with_field_values, event: event, conclude_event_type_id: nil) }

        it { expect(event.reload.conclude_event_type_id).to be_nil }
      end

      context "conclude_event_type_id is present" do
        let!(:event_milestone) { create(:event_milestone, :risk_assessment_with_field_values, event: event, conclude_event_type_id: event.event_type_id) }

        it { expect(event.reload.conclude_event_type_id).to eq(event.event_type_id) }
      end
    end
  end

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
