require 'rails_helper'

RSpec.describe Notification, type: :model do
  it { is_expected.to belong_to(:milestone) }
  it { is_expected.to have_many(:notification_chat_groups) }
  it { is_expected.to have_many(:chat_groups).through(:notification_chat_groups) }
  it { is_expected.to validate_presence_of(:message) }
end