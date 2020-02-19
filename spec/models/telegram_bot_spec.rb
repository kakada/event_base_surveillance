require 'rails_helper'

RSpec.describe TelegramBot, type: :model do
  it { is_expected.to belong_to(:program) }

  context 'is enabled bot' do
    before { allow(subject).to receive(:enabled?).and_return(true) }

    it { is_expected.to validate_presence_of(:token) }
    it { is_expected.to validate_presence_of(:username) }
  end

  context 'is not enabled bot' do
    before { allow(subject).to receive(:enabled?).and_return(false) }

    it { is_expected.not_to validate_presence_of(:token) }
    it { is_expected.not_to validate_presence_of(:username) }
  end
end
