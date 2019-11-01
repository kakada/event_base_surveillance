require 'rails_helper'

RSpec.describe EventMilestone, type: :model do
  it { is_expected.to belong_to(:event).with_foreign_key(:event_uuid) }
  it { is_expected.to belong_to(:milestone) }
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:submitter).class_name('User').optional }
  it { is_expected.to have_many(:field_values) }
end
