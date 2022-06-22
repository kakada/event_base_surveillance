# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProgramTelegramNotification, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:user) }
end
