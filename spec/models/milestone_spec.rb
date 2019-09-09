require 'rails_helper'

RSpec.describe Milestone, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to have_many(:fields).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:name) }
end
