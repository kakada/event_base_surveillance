require 'rails_helper'

RSpec.describe Event, type: :model do
  it { is_expected.to belong_to(:event_type).optional }
  it { is_expected.to belong_to(:creator).class_name('User').optional }
  it { is_expected.to have_many(:event_milestones).dependent(:destroy) }
  it { is_expected.to have_many(:field_values) }
  it { is_expected.to validate_presence_of(:location) }
  it { is_expected.to validate_presence_of(:event_date) }
  it { is_expected.to validate_presence_of(:report_date) }
  it { is_expected.to validate_presence_of(:number_of_case) }
end
