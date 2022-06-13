# frozen_string_literal: true

require "rails_helper"

RSpec.describe Message, type: :model do
  it { is_expected.to belong_to(:milestone) }
  it { is_expected.to have_one(:telegram_notification).class_name("Notifications::TelegramNotification") }
  it { is_expected.to have_one(:email_notification) }
  it { should validate_presence_of(:message) }
  it { should accept_nested_attributes_for(:email_notification).allow_destroy(true) }
  it { should accept_nested_attributes_for(:telegram_notification).allow_destroy(true) }
end
