# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventMilestones::RelevantEventMilestone do
  describe "#previous_event_milestone" do
    let!(:event) { create(:event) }
    let!(:verification) { create(:event_milestone, :verification, event: event, program: event.program) }

    it { expect(verification.previous_event_milestone).to eq(event) }

    context "new event_milestone" do
      let(:risk_assessment) { build(:event_milestone, :risk_assessment_with_field_values, event: event, program: event.program) }

      it { expect(risk_assessment.previous_event_milestone).to eq(verification) }
    end

    context "existing event_milestone" do
      let(:risk_assessment) { create(:event_milestone, :risk_assessment_with_field_values, event: event, program: event.program) }

      it { expect(risk_assessment.previous_event_milestone).to eq(verification) }
    end
  end

  describe "#relevant_event_milestone" do
    let!(:event) { create(:event) }
    let!(:verification) { create(:event_milestone, :verification, event: event, program: event.program) }

    it { expect(verification.relevant_event_milestone(event.milestone_id)).to eq(event) }

    context "relevant_milestone_id is previous_milestone" do
      let(:risk_assessment) { build(:event_milestone, :risk_assessment_with_field_values, event: event, program: event.program) }

      it { expect(risk_assessment.relevant_event_milestone(Milestone::PREVIOUS_MILESTONE)).to eq(verification) }
      it { expect(risk_assessment.relevant_event_milestone(verification.milestone_id.to_s)).to eq(verification) }
    end

    context "relevant_milestone_id is event milestone_id" do
      let(:risk_assessment) { build(:event_milestone, :risk_assessment_with_field_values, event: event, program: event.program) }

      it { expect(risk_assessment.relevant_event_milestone(event.milestone_id)).to eq(event) }
    end
  end
end
