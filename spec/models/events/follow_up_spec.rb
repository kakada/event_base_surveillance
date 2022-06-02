# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::FollowUp do
  describe '#reached_intervals' do
    let!(:schedule) { create(:schedule, interval_value: 3) }
    let!(:program) { schedule.program }
    let!(:event) { create(:event, program: program) }
    let(:query) { program.events.uncloseds.reached_intervals(schedule.interval_value) }

    context "reach duration date" do
      before { event.update_column(:updated_at, 3.days.ago) }

      it { expect(query.length).not_to be_zero }
    end

    context "not reach duration date yet" do
      before { event.update_column(:updated_at, 2.days.ago) }

      it { expect(query.length).to be_zero }
    end

    context "over duration date but not reach the interval" do
      before { event.update_column(:updated_at, 4.days.ago) }

      it { expect(query.length).to be_zero }
    end

    context "over duration date and reach the interval" do
      before { event.update_column(:updated_at, 6.days.ago) }

      it { expect(query.length).not_to be_zero }
    end
  end
end
