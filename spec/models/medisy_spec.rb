# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Medisy, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to have_many(:medisys_feeds).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:url) }
  it { is_expected.to validate_presence_of(:program_id) }
end
