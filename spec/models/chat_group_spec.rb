require 'rails_helper'

RSpec.describe ChatGroup, type: :model do
  it { is_expected.to have_many(:notification_chat_groups) }
  it { is_expected.to have_many(:notifications).through(:notification_chat_groups) }
end
