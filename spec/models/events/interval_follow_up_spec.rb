# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::IntervalFollowUp do
  describe '#reached_intervals' do
    let!(:interval_follow_up) { create(:interval_follow_up, duration_in_day: 3) }
    let!(:program) { interval_follow_up.program }
    let!(:event) { create(:event, program: program) }
    let(:query) { program.events.reached_intervals(interval_follow_up.duration_in_day) }

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
