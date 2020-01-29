require 'rails_helper'

RSpec.describe Tracing, type: :model do
  it { is_expected.to belong_to(:traceable) }
end
