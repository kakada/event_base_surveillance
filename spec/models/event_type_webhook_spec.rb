# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventTypeWebhook, type: :model do
  it { is_expected.to belong_to(:event_type) }
  it { is_expected.to belong_to(:webhook) }
end
