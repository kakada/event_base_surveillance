require 'rails_helper'

RSpec.describe Event, type: :model do
  it { is_expected.to belong_to(:event_type) }
  it { is_expected.to belong_to(:creator).class_name('User') }
  it { is_expected.to have_many(:forms).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:location) }
  it { is_expected.to validate_presence_of(:value) }
  it { is_expected.to validate_presence_of(:event_date) }
  it { is_expected.to validate_presence_of(:report_date) }
end
