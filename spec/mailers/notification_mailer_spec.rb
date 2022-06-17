# frozen_string_literal: true

require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "#notify" do
    let(:mail) { NotificationMailer.notify("receiver@instedd.org", "mail body") }

    it "renders the headers" do
      expect(mail.subject).to eq("CamEMS Notification")
      expect(mail.to).to eq(["receiver@instedd.org"])
      expect(NotificationMailer.default[:from]).to eq(ENV["SETTINGS__SMTP__DEFAULT_FROM"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("mail body")
    end
  end
end
