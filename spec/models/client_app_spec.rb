require 'rails_helper'

RSpec.describe ClientApp, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:ip_address) }

  describe '#before validate on create' do
    let(:client_app1) { create(:client_app, access_token: nil) }
    let(:client_app2) { create(:client_app, access_token: nil) }

    it 'assigns access_token on create' do
      expect(client_app1.access_token).not_to be_nil
    end

    it 'is invalid for duplicate token' do
      client_app2.access_token = client_app1.access_token
      expect(client_app2.save).to be_falsey
    end
  end
end
