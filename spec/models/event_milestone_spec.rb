require 'rails_helper'

RSpec.describe EventMilestone, type: :model do
  it { is_expected.to belong_to(:event).with_foreign_key(:event_uuid) }
  it { is_expected.to belong_to(:milestone) }
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:submitter).class_name('User').optional }
  it { is_expected.to have_many(:field_values) }

  describe '#validate_uniqueness_of milestone_id' do
    let!(:event_milestone) { create(:event_milestone, :risk_assessment_with_field_values) }
    let!(:event_milestone2) { build(:event_milestone, milestone_id: event_milestone.milestone.id, event: event_milestone.event, program: event_milestone.program) }

    it { expect(event_milestone2.save).to be_falsey }
    it { expect(event_milestone2.save && event_milestone2.errors.messages[:milestone_id]).not_to equal([]) }
  end
end
