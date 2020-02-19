# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationChatGroup, type: :model do
  it { is_expected.to belong_to(:notification) }
  it { is_expected.to belong_to(:chat_group) }
end
