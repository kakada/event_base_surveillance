# frozen_string_literal: true

require "rails_helper"

RSpec.describe MedisysCategory, type: :model do
  it { is_expected.to have_many(:medisys_feeds_categories) }
  it { is_expected.to have_many(:medisys_feeds).through(:medisys_feeds_categories) }
end
