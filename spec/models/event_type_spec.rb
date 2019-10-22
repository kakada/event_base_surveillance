require 'rails_helper'

RSpec.describe EventType, type: :model do
  it { is_expected.to have_many(:events) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:event_type_webhooks) }
  it { is_expected.to have_many(:webhooks).through(:event_type_webhooks) }
end
