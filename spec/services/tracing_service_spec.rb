# frozen_string_literal: true

require "rails_helper"

RSpec.describe TracingService do
  describe "#text_tracings" do
    let!(:event_milestone) { create(:event_milestone, :risk_assessment_with_field_values) }
    let!(:event) { event_milestone.event }
    let!(:risk_level) { event.program.fields.find_by(code: "risk_level") }
    let(:tracings) { TracingService.new(event).text_tracings }

    context "format tracing create_date" do
      it { expect(tracings[risk_level.id][:tracings].first["created_date"]).not_to be_nil }
    end

    context "not display_able" do
      it { expect(tracings[risk_level.id][:display_able]).to be_falsey }
      it { expect(tracings[risk_level.id][:tracings].length).to eq(1) }
    end

    context "display_able" do
      before {
        event.tracings.create(field_id: risk_level.id, field_value: "moderate", type: "Tracings::TextTracing")
      }

      it { expect(tracings[risk_level.id][:display_able]).to be_truthy }
    end

    context "take last 5 items" do
      before {
        %w(low high moderate very_high low moderate).each do |value|
          event.tracings.create(field_id: risk_level.id, field_value: value, type: "Tracings::TextTracing")
        end
      }

      it { expect(tracings[risk_level.id][:tracings].length).to eq(5) }
      it { expect(tracings[risk_level.id][:tracings].pluck("field_value")).to eq(%w(high moderate very_high low moderate)) }
    end
  end
end
