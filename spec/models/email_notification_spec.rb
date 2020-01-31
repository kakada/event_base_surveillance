# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailNotification, type: :model do
  it { is_expected.to belong_to(:message).required(false) }
end
