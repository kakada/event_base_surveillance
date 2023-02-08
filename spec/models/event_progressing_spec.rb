# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventProgressing, type: :model do
  let!(:program1) { create(:program) }
  let!(:program2) { create(:program) }
  let!(:event1) { create(:event, program: program1, created_at: 2.weeks.ago) }
  let!(:event2) { create(:event, program: program1) }
  let!(:event3) { create(:event, program: program2) }

  describe "#new_events" do
    context "in rank 1 week" do
      let(:data) { described_class.new(program1.id, 1.week.ago) }

      it "return only event2" do
        expect(data.new_events.length).to eq 1
        expect(data.new_events.pluck(:uuid)).to eq [event2.uuid]
      end
    end

    context "in rank 3 week" do
      let(:data) { described_class.new(program1.id, 3.week.ago) }

      it "return event1 and event2" do
        expect(data.new_events.length).to eq 2
        expect(data.new_events.pluck(:uuid)).to eq [event1.uuid, event2.uuid]
      end
    end
  end

  describe "#progressing_events" do
    context "within selected date rank 1 week" do
      let(:data) { described_class.new(program1.id, 1.week.ago) }

      context "status is new" do
        it "has no event progressing" do
          progress_field = event1.get_value_by_code('progress')
          progress_field.update(value: program1.milestones.root.name)
          event1.save

          expect(data.progressing_events.length).to eq 0
        end
      end

      context "status is verification" do
        it "has 1 event progressing" do
          progress_field = event1.get_value_by_code('progress')
          progress_field.update(value: "Verification")
          event1.save

          expect(data.progressing_events.length).to eq 1
        end
      end
    end

    context "within selected date rank 3 week" do
      let(:data) { described_class.new(program1.id, 3.week.ago) }

      context "status is verification" do
        it "has no event progressing" do
          progress_field = event1.get_value_by_code('progress')
          progress_field.update(value: "Verification")
          event1.save

          expect(data.progressing_events.length).to eq 0
        end
      end
    end
  end
end
