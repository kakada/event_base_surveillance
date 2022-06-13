# frozen_string_literal: true

require "rails_helper"

RSpec.describe Webhook, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:type) }
  it { is_expected.to have_many(:event_type_webhooks) }
  it { is_expected.to have_many(:event_types).through(:event_type_webhooks) }

  describe "#username, #password" do
    context "is basic auth" do
      before { allow(subject).to receive(:type).and_return(Webhooks::BasicAuth.name) }
      it { is_expected.to validate_presence_of(:username) }
      it { is_expected.to validate_presence_of(:password) }
    end

    context "is not basic auth" do
      before { allow(subject).to receive(:type).and_return(Webhooks::TokenAuth.name) }
      it { is_expected.not_to validate_presence_of(:username) }
      it { is_expected.not_to validate_presence_of(:password) }
    end
  end

  describe "#token" do
    context "is token auth" do
      before { allow(subject).to receive(:type).and_return(Webhooks::TokenAuth.name) }
      it { is_expected.to validate_presence_of(:token) }
    end

    context "is not token auth" do
      before { allow(subject).to receive(:type).and_return(Webhooks::BasicAuth.name) }
      it { is_expected.not_to validate_presence_of(:token) }
    end
  end
end
