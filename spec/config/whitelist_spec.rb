# frozen_string_literal: true

require "rails_helper"

RSpec.describe Whitelist do
  describe ".matches?" do
    let(:req) { OpenStruct.new(remote_ip: "91.108.6.80") }

    context "development" do
      before :each do
        allow(Rails.env).to receive(:development?).and_return(true)
      end

      it { expect(Whitelist.matches?(req)).to be_truthy }
    end

    context "ip address is in whitelist" do
      before :each do
        stub_const("ENV", { "ALLOWED_HOSTS" => "91.108.6.80, 192.168.0.2" })
      end

      it { expect(Whitelist.matches?(req)).to be_truthy }
    end

    context "ip block is in whitelist" do
      before :each do
        stub_const("ENV", { "ALLOWED_HOSTS" => "192.168.0.2, 91.108.4.0/22" })
      end

      it { expect(Whitelist.matches?(req)).to be_truthy }
    end

    context "ip address is not in whitelist" do
      before :each do
        stub_const("ENV", { "ALLOWED_HOSTS" => "192.168.0.3" })
      end

      it { expect(Whitelist.matches?(req)).to be_falsey }
    end

    context "ip block is not in whitelist" do
      before :each do
        stub_const("ENV", { "ALLOWED_HOSTS" => "91.108.0.0/22" })
      end

      it { expect(Whitelist.matches?(req)).to be_falsey }
    end
  end
end
