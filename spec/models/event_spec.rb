require 'rails_helper'

RSpec.describe Event, type: :model do
  it { is_expected.to belong_to(:event_type) }
  it { is_expected.to belong_to(:creator).class_name('User') }
  it { is_expected.to have_many(:form_values) }
  it { is_expected.to have_many(:field_values) }
end
