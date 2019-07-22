require 'rails_helper'

RSpec.describe FormType, type: :model do
  it { is_expected.to belong_to(:event_type) }
  it { is_expected.to have_many(:fields) }
  it { is_expected.to have_many(:forms) }
  it { is_expected.to validate_presence_of(:name) }
end
