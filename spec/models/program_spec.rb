# frozen_string_literal: true

require "rails_helper"

RSpec.describe Program, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:client_apps) }
  it { is_expected.to have_many(:events) }
  it { is_expected.to have_many(:event_types) }
  it { is_expected.to have_many(:milestones) }
  it { is_expected.to have_many(:webhooks) }
  it { is_expected.to have_many(:templates) }
  it { is_expected.to validate_inclusion_of(:national_zoom_level).in_array((0..20).to_a) }
  it { is_expected.to validate_inclusion_of(:provincial_zoom_level).in_array((0..20).to_a) }
end
