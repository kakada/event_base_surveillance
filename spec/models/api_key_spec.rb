require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:ip_address) }

  describe '#before validate on create' do
    let(:api_key1) { create(:api_key, access_token: nil) }
    let(:api_key2) { create(:api_key, access_token: nil) }

    it 'assigns access_token on create' do
      expect(api_key1.access_token).not_to be_nil
    end

    it 'is invalid for duplicate token' do
      api_key2.access_token = api_key1.access_token
      expect(api_key2.save).to be_falsey
    end
  end
end
